{
  pkgs,
  config,
  ...
}: {
  config.modules.system = {
    mainUser = "justin";

    fs.zfs = {
      enable = true;
      autoScrub = true;
      poolsToImport = ["zpool"];
      snapshots = true;
    };

    boot = {
      loader = "none";
      secureBoot = true;
      plymouth = {
        enable = true;
        withThemes = true;
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
      };
    };

    security = {
      fprint.enable = true;
    };

    programs = {
      cli.enable = true;
      gui.enable = true;
      dev.enable = true;

      fish.enable = true;

      default = {
        browser = "firefox";
        launcher = "anyrun";
        editor = "neovim";
      };
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
