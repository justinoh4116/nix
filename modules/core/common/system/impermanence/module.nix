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
            ".config/timewarrior"
            ".local/share/timewarrior"
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
            # ".config/niri/noctalia.kdl"
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
