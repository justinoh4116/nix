{
  pkgs,
  config,
  ...
}:
{
  config.modules.system = {
    mainUser = "justin";

    fs.zfs = {
      enable = true;
      autoScrub = true;
      poolsToImport = [ "zpool" ];
      snapshots = true;
    };

    boot = {
      loader = "grub";
      secureBoot = false;
    };

    networking = {
      tailscale = {
        enable = true;
        isServer = true;
      };
    };

    programs = {
      cli.enable = true;

      fish.enable = true;
    };

    services = {
      cachix-agent = {
        enable = true;
        credentialsFile = config.age.secrets.titanic-cachix-agent-token.path;
      };
      media-server.enable = true;
    };
  };
}
