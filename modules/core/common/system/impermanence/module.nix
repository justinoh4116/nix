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

          tmp_mount=/btrfs_tmp
          root_subvol="$tmp_mount/local/root"
          root_archives="$tmp_mount/local/old_roots"
          home_subvol="$tmp_mount/safe/home"
          home_archives="$tmp_mount/local/old_homes"

          mounted=0
          cleanup() {
            if (( mounted )); then
              umount "$tmp_mount"
            fi
          }
          trap cleanup EXIT

          mkdir -p "$tmp_mount"
          echo "[cleanup] Mounting ${config.fileSystems."/".device} at $tmp_mount"
          mount -o subvol=/ ${config.fileSystems."/".device} "$tmp_mount"
          mounted=1

          delete_subvolume_recursively() {
            local subvol="$1"
            local nested

            while IFS= read -r nested; do
              [[ -n "$nested" ]] || continue
              echo "[cleanup] Recursively deleting subvolume $tmp_mount/$nested"
              delete_subvolume_recursively "$tmp_mount/$nested"
            done < <(btrfs subvolume list -o "$subvol" | cut -f 9- -d ' ')

            echo "[cleanup] Deleting subvolume $subvol"
            btrfs subvolume delete "$subvol"
          }

          cleanup_archives() {
            local target_dir="$1"
            local archive_count

            [[ -d "$target_dir" ]] || return

            archive_count=$(find "$target_dir" -mindepth 1 -maxdepth 1 -type d | wc -l)

            while IFS= read -r archive; do
              if (( archive_count <= 10 )); then
                break
              fi

              delete_subvolume_recursively "$archive"
              archive_count=$((archive_count - 1))
            done < <(
              find "$target_dir" -mindepth 1 -maxdepth 1 -type d -mtime +30 -printf '%T@ %p\n' \
                | sort -n \
                | cut -d' ' -f2-
            )
          }

          rotate_subvolume() {
            local source="$1"
            local archive_dir="$2"
            local label="$3"
            local timestamp

            mkdir -p "$archive_dir"

            if [[ -e "$source" ]]; then
              timestamp=$(date --date="@$(stat -c %Y "$source")" "+%Y-%m-%d_%H-%M-%S")
              echo "[cleanup] Found $source, moving to $archive_dir/$timestamp"
              mv "$source" "$archive_dir/$timestamp"
            else
              echo "[cleanup] $source does not exist, skipping move"
            fi

            cleanup_archives "$archive_dir"

            echo "[cleanup] Creating new subvolume $source for $label"
            btrfs subvolume create "$source"
          }

          rotate_subvolume "$root_subvol" "$root_archives" root
          rotate_subvolume "$home_subvol" "$home_archives" home
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

            ".config/net.imput.helium"
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
            ".local/share/soulver-core"
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
            ".local/bin"
            ".local/lib/soulver-cpp"
            ".local/lib/swift-6.1"
            ".local/share/headroom-venv"
            ".headroom"
            ".config/t3code"
            ".codex"
            ".t3"

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
