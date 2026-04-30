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
    boot.initrd.systemd = lib.mkIf sys.fs.btrfs.enable {
      services.impermanence-btrfs = {
        description = "Impermanence Btrfs cleanup service";
        unitConfig.DefaultDependencies = false;
        requiredBy = ["sysroot.mount"];
        requires = ["initrd-root-device.target"];
        before = ["sysroot.mount"];
        after = [
          "initrd-root-device.target"
          "systemd-hibernate-resume.service"
        ];
        serviceConfig = {
          Type = "oneshot";
          StandardOutput = "journal+console";
          StandardError = "journal+console";
        };
        script = ''
          set -euo pipefail

          mounted=0
          cleanup() {
            if (( mounted )); then
              umount /btrfs_tmp
            fi
          }
          trap cleanup EXIT

          mkdir -p /btrfs_tmp
          echo "[cleanup] Mounting ${config.fileSystems."/".device} at /btrfs_tmp"
          mount -o subvol=/ ${config.fileSystems."/".device} /btrfs_tmp
          mounted=1

          mkdir -p /btrfs_tmp/local/snapshots/root

          if [[ -e /btrfs_tmp/local/root ]]; then
            timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/local/root)" "+%Y-%m-%d_%H:%M:%S")
            echo "[cleanup] Found /btrfs_tmp/local/root, moving to /btrfs_tmp/local/snapshots/root/$timestamp"
            mv /btrfs_tmp/local/root "/btrfs_tmp/local/snapshots/root/$timestamp"
          else
            echo "[cleanup] /btrfs_tmp/local/root does not exist, skipping move"
          fi

          delete_subvolume_recursively() {
            local subvol="$1"

            while IFS= read -r nested; do
              echo "[cleanup] Recursively deleting subvolume /btrfs_tmp/$nested"
              delete_subvolume_recursively "/btrfs_tmp/$nested"
            done < <(btrfs subvolume list -o "$subvol" | cut -f 9- -d ' ')

            echo "[cleanup] Deleting subvolume $subvol"
            btrfs subvolume delete "$subvol"
          }

          cleanup_snapshots() {
            local target_dir="$1"
            local snapshot_count

            [[ -d "$target_dir" ]] || return

            snapshot_count=$(find "$target_dir" -mindepth 1 -maxdepth 1 -type d | wc -l)

            while IFS= read -r snapshot; do
              if (( snapshot_count <= 10 )); then
                break
              fi

              if [[ $(find "$snapshot" -maxdepth 0 -mtime +30) ]]; then
                delete_subvolume_recursively "$snapshot"
                snapshot_count=$((snapshot_count - 1))
              fi
            done < <(
              find "$target_dir" -mindepth 1 -maxdepth 1 -type d -printf '%T@ %p\n' \
                | sort -n \
                | cut -d' ' -f2-
            )
          }

          cleanup_snapshots /btrfs_tmp/local/snapshots/root

          echo "[cleanup] Creating new subvolume /btrfs_tmp/local/root"
          btrfs subvolume create /btrfs_tmp/local/root

          mkdir -p /btrfs_tmp/local/snapshots/home

          if [[ -e /btrfs_tmp/safe/home ]]; then
            timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/safe/home)" "+%Y-%m-%d_%H:%M:%S")
            echo "[cleanup] Found /btrfs_tmp/safe/home, moving to /btrfs_tmp/local/snapshots/home/$timestamp"
            mv /btrfs_tmp/safe/home "/btrfs_tmp/local/snapshots/home/$timestamp"
          else
            echo "[cleanup] /btrfs_tmp/safe/home does not exist, skipping move"
          fi

          cleanup_snapshots /btrfs_tmp/local/snapshots/home

          echo "[cleanup] Creating new subvolume /btrfs_tmp/safe/home"
          btrfs subvolume create /btrfs_tmp/safe/home
        '';
      };

      extraBin = {
        bash = "${pkgs.bash}/bin/bash";
        btrfs = "${pkgs.btrfs-progs}/bin/btrfs";
        cut = "${pkgs.coreutils}/bin/cut";
        date = "${pkgs.coreutils}/bin/date";
        echo = "${pkgs.coreutils}/bin/echo";
        find = "${pkgs.findutils}/bin/find";
        mkdir = "${pkgs.coreutils}/bin/mkdir";
        mv = "${pkgs.coreutils}/bin/mv";
        sort = "${pkgs.coreutils}/bin/sort";
        stat = "${pkgs.coreutils}/bin/stat";
        wc = "${pkgs.coreutils}/bin/wc";
      };
    };

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
            ".config/t3code"
            ".codex"
            ".vscode"
            ".tmux/resurrect"
            ".local/bin"
            ".local/share/headroom-venv"

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
