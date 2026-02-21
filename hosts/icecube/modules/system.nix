{
  pkgs,
  config,
  ...
}: {
  config.modules.system = {
    mainUser = "justin";

    fs.btrfs = {
      enable = true;
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
        browser = "floorp";
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
}
