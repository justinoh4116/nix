{
  pkgs,
  config,
  ...
}: {
  config = {
    modules.system = {
      mainUser = "justin";

      fs.btrfs = {
        enable = true;
        snapshots = true;
      };

      fs.zfs = {
        enable = false;
        autoScrub = true;
        poolsToImport = ["zpool"];
        snapshots = true;
      };

      boot = {
        loader = "systemd-boot";
        secureBoot = false;
        plymouth = {
          enable = false;
          # withThemes = true;
        };
      };

      impermanence = {
        root.enable = true;
        home.enable = true;
      };

      video.enable = true;
      sound.enable = true;
      bluetooth.enable = true;
      printing.enable = true;

      networking = {
        tailscale = {
          enable = true;
          # autoConnect = false;
        };
      };

      security = {
        fprint.enable = true;
      };

      programs = {
        cli.enable = true;
        gui.enable = true;
        dev.enable = true;

        distrobox.enable = true;

        fish.enable = true;

        discord.enable = true;

        browsers.floorp.enable = true;

        default = {
          browser = "zen";
          launcher = "anyrun";
          editor = "neovim";
        };

        steam.enable = true;
      };

      services = {
        cachix-agent = {
          enable = true;
          credentialsFile = config.age.secrets.framework-cachix-agent-token.path;
        };
        bolt.enable = true;
      };
    };
    services.logind.settings.Login = {
      HandlePowerKey = "sleep";
      HandleLidSwitch = "ignore";
      HandleLidSwitchExternalPower = "ignore";
      HandleLidSwitchDocked = "ignore";
    };
    services.kanata = {
      enable = true;
      keyboards.internal = {
        devices = ["/dev/input/by-path/platform-i8042-serio-0-event-kbd"];
        extraDefCfg = ''
          process-unmapped-keys yes
        '';
        config = ''
          (defsrc
            caps h j k l
          )

          (defalias
            src use-defsrc
            nav (layer-while-held nav)
            capnav (tap-hold-press 200 200 esc @nav)
          )

          (deflayer base
            @capnav @src @src @src @src
          )

          (deflayer nav
            _ left down up rght
          )
        '';
      };
    };
  };
}
