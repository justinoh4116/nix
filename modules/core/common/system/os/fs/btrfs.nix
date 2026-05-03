{
  config,
  lib,
  pkgs,
  ...
}: let
  sys = config.modules.system;
  cfg = sys.fs.btrfs;
  imp = sys.impermanence;

  rootDevice = lib.attrByPath ["fileSystems" "/" "device"] null config;
  rootFsType = lib.attrByPath ["fileSystems" "/" "fsType"] null config;
  homeDevice = lib.attrByPath ["fileSystems" "/home" "device"] null config;
  homeFsType = lib.attrByPath ["fileSystems" "/home" "fsType"] null config;

  rollbackEnabled = cfg.enable && imp.root.enable && imp.home.enable;
  initrdDeps =
    lib.optional (config.boot.initrd.luks.devices ? cryptroot) "systemd-cryptsetup@cryptroot.service"
    ++ ["initrd-root-device.target"];
in {
  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      assertions = lib.optionals rollbackEnabled [
        {
          assertion = rootFsType == "btrfs";
          message = "Btrfs rollback requires `fileSystems.\"/\".fsType = \"btrfs\"`.";
        }
        {
          assertion = homeFsType == "btrfs";
          message = "Btrfs rollback requires `fileSystems.\"/home\".fsType = \"btrfs\"`.";
        }
        {
          assertion = rootDevice == homeDevice;
          message = "Btrfs rollback expects `/` and `/home` to live on the same Btrfs filesystem.";
        }
      ];
    })

    (lib.mkIf (cfg.enable && cfg.snapshots) {
      fileSystems."/btrfs" = {
        device = config.fileSystems."/".device;
        fsType = "btrfs";
        options = ["subvol=/" "noatime"];
      };

      systemd.tmpfiles.rules = [
        "d /btrfs/safe/snapshots 0755 root root -"
        "d /btrfs/local/snapshots 0755 root root -"
        "d /btrfs/local/snapshots/root 0755 root root -"
        "d /btrfs/safe/snapshots/home 0755 root root -"
        "d /btrfs/safe/snapshots/persist 0755 root root -"
      ];

      services.btrbk.instances.safe = {
        onCalendar = "*:0/15";
        snapshotOnly = true;
        settings = {
          timestamp_format = "long";
          snapshot_preserve_min = "24h";
          snapshot_preserve = "14d 8w 12m";

          volume."/btrfs" = {
            subvolume."safe/home" = {
              snapshot_dir = "safe/snapshots/home";
            };

            subvolume."safe/persist" = {
              snapshot_dir = "safe/snapshots/persist";
            };

            subvolume."local/root" = {
              snapshot_dir = "local/snapshots/root";
            };
          };
        };
      };
    })

    (lib.mkIf rollbackEnabled {
      boot.initrd.systemd = {
        enable = true;
        extraBin = {
          btrfs = "${pkgs.btrfs-progs}/bin/btrfs";
        };
        services.btrfs-wipe = {
          description = "Rollback Btrfs root and home subvolumes to pristine snapshots";
          wantedBy = ["initrd.target"];
          requires = initrdDeps;
          after = initrdDeps ++ ["systemd-hibernate-resume.service"];
          before = ["sysroot.mount"];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = ''
            set -eu

            MOUNTDIR=/mnt
            BTRFS_VOL='${rootDevice}'
            ROOT_SUBVOL="$MOUNTDIR/local/root"
            ROOT_BLANK="$MOUNTDIR/local/root-blank"
            HOME_SUBVOL="$MOUNTDIR/safe/home"
            HOME_BLANK="$MOUNTDIR/safe/home-blank"

            ${pkgs.coreutils}/bin/mkdir -p "$MOUNTDIR"

            if [ ! -e "$BTRFS_VOL" ]; then
              >&2 echo "Device '$BTRFS_VOL' not found"
              exit 1
            fi

            mounted=0
            cleanup() {
              if [ "$mounted" -eq 1 ]; then
                umount "$MOUNTDIR"
              fi
            }
            trap cleanup EXIT

            mount -t btrfs -o subvolid=5,user_subvol_rm_allowed "$BTRFS_VOL" "$MOUNTDIR"
            mounted=1

            for subvol in "$ROOT_BLANK" "$HOME_BLANK"; do
              if [ ! -d "$subvol" ]; then
                >&2 echo "Blank snapshot '$subvol' not found"
                exit 1
              fi
            done

            if [ -e "$ROOT_SUBVOL" ]; then
              btrfs subvolume delete -R "$ROOT_SUBVOL"
            fi

            if [ -e "$HOME_SUBVOL" ]; then
              btrfs subvolume delete -R "$HOME_SUBVOL"
            fi

            echo "Restoring blank / subvolume..."
            btrfs subvolume snapshot "$ROOT_BLANK" "$ROOT_SUBVOL"

            echo "Restoring blank /home subvolume..."
            btrfs subvolume snapshot "$HOME_BLANK" "$HOME_SUBVOL"
          '';
        };
      };
    })
  ];
}
