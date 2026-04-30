{
  self,
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  sys = config.modules.system;
  cfg = sys.impermanence;

  inherit (lib) mkIf isWSL;
in {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  config = mkIf (cfg.enable && !isWSL config) {
    # boot.initrd.systemd = {
    #   services.impermanence-btrfs = lib.mkIf sys.fs.btrfs.enable {
    #     description = "Impermanence Btrfs cleanup service";
    #     # Specify dependencies explicitly
    #     unitConfig.DefaultDependencies = false;
    #     # The script needs to run to completion before this service is done
    #     serviceConfig = {
    #       Type = "oneshot";
    #       # NOTE: to be able to see errors in your script do this
    #       StandardOutput = "journal+console";
    #       StandardError = "journal+console";
    #     };
    #     wantedBy = ["initrd.target"];
    #     after = [
    #       "initrd-root-device.target"
    #       "cryptsetup.target"
    #     ];
    #     # # This service is required for boot to succeed
    #     # requiredBy = ["initrd.target"];
    #     # # Should complete before any file systems are mounted
    #     # before = [""];
    #     # wantedBy = ["local-fs-pre.target"];
    #     #
    #     # # Wait until the root device is available
    #     # # If you're altering a different device, specify its device unit explicitly.
    #     # # see: systemd-escape(1)
    #     # requires = ["cryptsetup.target"];
    #     # after = [
    #     #   # "initrd-root-device.target"
    #     #   "cryptsetup.target"
    #     #   # Allow hibernation to resume before trying to alter any data
    #     #   "local-fs-pre.target"
    #     # ];
    #
    #     # The body of the script. Make your changes to data here
    #     script = ''
    #       #!${pkgs.bash}/bin/bash
    #       mkdir -p /btrfs_tmp
    #       echo "[cleanup] Created /btrfs_tmp"
    #       mount /dev/mapper/cryptroot /btrfs_tmp
    #       mkdir -p /btrfs_tmp/local/snapshots/root
    #
    #       if [[ -e /btrfs_tmp/local/root ]]; then
    #           timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/local/root)" "+%Y-%m-%d_%H:%M:%S")
    #           echo "[cleanup] Found /btrfs_tmp/local/root, moving to /btrfs_tmp/local/snapshots/root/$timestamp"
    #           mv /btrfs_tmp/local/root "/btrfs_tmp/local/snapshots/root/$timestamp"
    #       else
    #           echo "[cleanup] /btrfs_tmp/local/root does not exist, skipping move"
    #       fi
    #
    #       delete_subvolume_recursively() {
    #           local subvol="$1"
    #           IFS=$'\n'
    #           for i in $(btrfs subvolume list -o "$subvol" | cut -f 9- -d ' '); do
    #               echo "[cleanup] Recursively deleting subvolume /btrfs_tmp/$i"
    #               delete_subvolume_recursively "/btrfs_tmp/$i"
    #           done
    #           echo "[cleanup] Deleting subvolume $subvol"
    #           btrfs subvolume delete "$subvol"
    #       }
    #
    #       cleanup_snapshots() {
    #           target_dir="$1"
    #
    #           # Skip if directory doesn't exist
    #           [[ -d "$target_dir" ]] || return
    #
    #           snapshot_count=$(find "$target_dir" -mindepth 1 -maxdepth 1 -type d | wc -l)
    #
    #           find "$target_dir" -mindepth 1 -maxdepth 1 -type d -printf '%T@ %p\n' | \
    #           sort -n | cut -d' ' -f2- | \
    #           while IFS= read -r snapshot; do
    #
    #               if (( snapshot_count <= 10 )); then
    #                   break
    #               fi
    #
    #               if [[ $(find "$snapshot" -maxdepth 0 -mtime +30) ]]; then
    #                   delete_subvolume_recursively "$snapshot"
    #                   snapshot_count=$((snapshot_count - 1))
    #               fi
    #
    #           done
    #       }
    #
    #       cleanup_snapshots /btrfs_tmp/local/root
    #
    #       echo "[cleanup] Creating new subvolume /btrfs_tmp/local/root"
    #       btrfs subvolume create /btrfs_tmp/local/root
    #
    #       mkdir -p /btrfs_tmp/local/snapshots/home
    #
    #       if [[ -e /btrfs_tmp/safe/home ]]; then
    #           timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/safe/home)" "+%Y-%m-%d_%H:%M:%S")
    #           echo "[cleanup] Found /btrfs_tmp/safe/home, moving to /btrfs_tmp/local/snapshots/home/$timestamp"
    #           mv /btrfs_tmp/safe/home "/btrfs_tmp/local/snapshots/home/$timestamp"
    #       else
    #           echo "[cleanup] /btrfs_tmp/safe/home does not exist, skipping move"
    #       fi
    #
    #       cleanup_snapshots /btrfs_tmp/local/snapshots/home
    #
    #       echo "[cleanup] Creating new subvolume /btrfs_tmp/safe/home"
    #       btrfs subvolume create /btrfs_tmp/safe/home
    #
    #       echo "[cleanup] Unmounted /btrfs_tmp"
    #       umount /btrfs_tmp
    #     '';
    #     # NOTE: path = [...]; doesnt work for initrd, use full paths in your script or extraBin
    #   };
    #   services.impermanence-zfs = lib.mkIf sys.fs.zfs.enable {
    #     description = "Impermanence zfs cleanup service";
    #     # Specify dependencies explicitly
    #     unitConfig.DefaultDependencies = false;
    #     # The script needs to run to completion before this service is done
    #     serviceConfig = {
    #       Type = "oneshot";
    #       # NOTE: to be able to see errors in your script do this
    #       # StandardOutput = "journal+console";
    #       # StandardError = "journal+console";
    #     };
    #     # This service is required for boot to succeed
    #     requiredBy = ["initrd.target"];
    #     # Should complete before any file systems are mounted
    #     before = ["sysroot.mount"];
    #
    #     # Wait until the root device is available
    #     # If you're altering a different device, specify its device unit explicitly.
    #     # see: systemd-escape(1)
    #     requires = ["initrd-root-device.target"];
    #     after = [
    #       "initrd-root-device.target"
    #       # Allow hibernation to resume before trying to alter any data
    #       "local-fs-pre.target"
    #     ];
    #
    #     # The body of the script. Make your changes to data here
    #     script = ''
    #       zfs rollback -r zpool/local/root@blank
    #       zfs rollback -r zpool/safe/home@blank
    #     '';
    #   };
    #   extraBin = {
    #     "bash" = "${pkgs.bash}/bin/bash";
    #     # "mkfs.ext4" = "${pkgs.e2fsprogs}/bin/mkfs.ext4";
    #     "mkdir" = "${pkgs.coreutils}/bin/mkdir";
    #     "wc" = "${pkgs.coreutils}/bin/wc";
    #     "cut" = "${pkgs.coreutils}/bin/cut";
    #     "sort" = "${pkgs.coreutils}/bin/sort";
    #     "date" = "${pkgs.coreutils}/bin/date";
    #     "stat" = "${pkgs.coreutils}/bin/stat";
    #     "mv" = "${pkgs.coreutils}/bin/mv";
    #     "echo" = "${pkgs.coreutils}/bin/echo";
    #     "find" = "${pkgs.findutils}/bin/find";
    #     "btrfs" = "${pkgs.btrfs-progs}/bin/btrfs";
    #     "zfs" = "${pkgs.zfs}/bin/zfs";
    #     # mount & umount already exist
    #   };
    # };

    environment.persistence."/persist" = {
      enable = cfg.root.enable;
      hideMounts = true;
      directories =
        [
          # "/etc/cups"
          "/var/lib/bluetooth"
          "/var/lib/sbctl"
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
          "/etc/NetworkManager/system-connections"
          "/var/lib/fprint"
          "/var/lib/tailscale"
          "/etc/ssh"
        ]
        ++ cfg.root.extraDirectories;
      files =
        [
          "/etc/machine-id"
        ]
        ++ cfg.root.extraFiles;
      users.justin = {
        directories =
          [
            ".steam"
            ".local/share/Steam"

            ".config/spotify"
            ".config/vicinae"
            ".local/share/vicinae"
            ".local/state/vicinae"
            ".cache/vicinae"

            ".config/tms"
            ".zen"
            ".mozilla"
            ".floorp"
            ".cache/floorp"
            ".cache/Tectonic"
            ".config/discordcanary"
            ".config/github-copilot"
            ".config/pulse"
            ".vim"
            ".local/share/fish"
            ".local/share/containers"
            ".local/share/z"
            ".local/state/nvim"
            ".local/state/wireplumber"
            ".local/share/nvim"
            "safe"
            ".local/state/syncthing"
            ".config/fish"
            ".config/google-chrome"
            ".local/share/sioyek"
            ".config/obsidian"
            ".config/Nextcloud"
            ".config/inkscape"
            ".config/PrusaSlicer"
            ".config/cachix"
            ".zotero"
            ".cache/nvim"
            ".config/easyeffects"
            ".local/share/easyeffects"
            ".cache/easyeffects"
            ".config/Code"
            ".vscode"
            ".tmux/resurrect"

            {
              directory = ".gnupg";
              mode = "0700";
            }
            {
              directory = ".ssh";
              mode = "0700";
            }
            {
              directory = ".local/share/keyrings";
              mode = "0700";
            }
            ".local/share/direnv"
          ]
          ++ cfg.home.extraDirectories;
        files =
          [
            ".screenrc"
            ".config/dolphinrc"
            ".local/state/dolphinstaterc"
            ".local/share/user-places.xbel"
            ".config/niri/noctalia.kdl"
          ]
          ++ cfg.home.extraFiles;
      };
    };

    services.openssh.hostKeys = [
      {
        path = "/persist/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
        bits = 4096;
      }
      {
        path = "/persist/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };
}
