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
    boot.initrd = lib.mkMerge [
      (lib.mkIf (sys.fs.zfs.enable) {
        postResumeCommands = lib.mkAfter ''
          zfs rollback -r zpool/local/root@blank
          zfs rollback -r zpool/safe/home@blank
        '';
      })
      (lib.mkIf (sys.fs.btrfs.enable) {
        postResumeCommands = lib.mkAfter ''
          mkdir -p /btrfs_tmp
          echo "[cleanup] Created /btrfs_tmp"
          mount /dev/mapper/cryptroot btrfs_tmp
          mkdir -p /btrfs_tmp/persist/snapshots/root

          if [[ -e /btrfs_tmp/root ]]; then
              timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%d_%H:%M:%S")
              echo "[cleanup] Found /btrfs_tmp/root, moving to /btrfs_tmp/persist/snapshots/root/$timestamp"
              mv /btrfs_tmp/root "/btrfs_tmp/persist/snapshots/root/$timestamp"
          else
              echo "[cleanup] /btrfs_tmp/root does not exist, skipping move"
          fi

          delete_subvolume_recursively() {
              local subvol="$1"
              IFS=$'\n'
              for i in $(btrfs subvolume list -o "$subvol" | cut -f 9- -d ' '); do
                  echo "[cleanup] Recursively deleting subvolume /btrfs_tmp/$i"
                  delete_subvolume_recursively "/btrfs_tmp/$i"
              done
              echo "[cleanup] Deleting subvolume $subvol"
              btrfs subvolume delete "$subvol"
          }

          find /btrfs_tmp/persist/snapshots/root -maxdepth 1 -mtime +30 -type d | while read snapshot; do
              echo "[cleanup] Deleting old snapshot $snapshot"
              delete_subvolume_recursively "$snapshot"
          done

          echo "[cleanup] Creating new subvolume /btrfs_tmp/root"
          btrfs subvolume create /btrfs_tmp/root

          echo "[cleanup] Unmounted /btrfs_tmp"
          umount /btrfs_tmp
        '';
      })
    ];

    environment.persistence."/persist" = {
      enable = cfg.root.enable;
      hideMounts = true;
      directories =
        [
          "/etc/cups"
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
            ".zen"
            ".mozilla"
            ".floorp"
            ".cache/floorp"
            ".config/discordcanary"
            ".vim"
            ".local/share/fish"
            ".local/share/z"
            ".local/state/nvim"
            ".local/state/wireplumber"
            ".local/share/nvim"
            "safe"
            ".local/state/syncthing"
            ".config/fish"
            ".config/google-chrome"
            ".config/obsidian"
            ".config/Nextcloud"
            ".config/inkscape"
            ".config/PrusaSlicer"
            ".config/cachix"
            ".zotero"
            ".cache/nvim"

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
