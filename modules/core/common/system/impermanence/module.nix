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
    boot.initrd.postResumeCommands = mkIf sys.fs.zfs.enable (lib.mkAfter ''
      zfs rollback -r zpool/local/root@blank
      zfs rollback -r zpool/safe/home@blank
    '');

    environment.persistence."/persist" = {
      enable = cfg.root.enable;
      hideMounts = true;
      directories =
        [
          "/etc/cups"
          "/var/log"
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
