{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption literalExpression;

  cfg = config.modules.misc.impermanence;
in {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options.modules.misc.impermanence = {
    enable = mkOption {
      default = cfg.root.enable || cfg.home.enable;
      readOnly = true;
      description = ''
        Internal option for deciding if Impermanence module is enabled
        based on the values of `modules.system.impermanence.root.enable`
        and `modules.system.impermanence.home.enable`.
      '';
    };

    root = {
      enable = mkEnableOption ''
        the Impermanence module for persisting important state directories.
        By default, Impermanence will not touch user's $HOME, which is not
        ephemeral unlike root.
      '';

      extraFiles = mkOption {
        default = [];
        example = literalExpression ''["/etc/nix/id_rsa"]'';
        description = ''
          Additional files in the root to link to persistent storage.
        '';
      };

      extraDirectories = mkOption {
        default = [];
        example = literalExpression ''["/var/lib/libvirt"]'';
        description = ''
          Additional directories in the root to link to persistent
          storage.
        '';
      };
    };

    home = {
      enable = mkEnableOption ''
        the Impermanence module for persisting important state directories.
        This option will also make user's home ephemeral, on top of the root subvolume
      '';

      # mountDotfiles = mkOption {
      #   default = true;
      #   description = ''
      #     Whether the repository with my configuration flake should be bound to a location
      #     in $HOME after a rebuild. It will symlink ''${self} to ~/.config/nyx where I
      #     usually put my configuration files
      #   '';
      # };

      extraFiles = mkOption {
        default = [];
        example = literalExpression ''
          [
            ".gnupg/pubring.kbx"
            ".gnupg/sshcontrol"
            ".gnupg/trustdb.gpg"
            ".gnupg/random_seed"
          ]
        '';
        description = ''
          Additional files in the home directory to link to persistent
          storage.
        '';
      };

      extraDirectories = mkOption {
        default = [];
        example = literalExpression ''[".config/gsconnect"]'';
        description = ''
          Additional directories in the home directory to link to
          persistent storage.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot.initrd.postResumeCommands = lib.mkAfter ''
      zfs rollback -r zpool/local/root@blank
      zfs rollback -r zpool/safe/home@blank
    '';

    environment.persistence."/persist" = {
      enable = true; # NB: Defaults to true, not needed
      hideMounts = true;
      directories = [
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
      ];
      files = [
        "/etc/machine-id"
      ];
      users.justin = {
        directories = [
          ".steam"
          ".local/share/Steam"

          ".zen"
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
        ];
        files = [
          ".screenrc"
        ];
      };
    };
  };
}
