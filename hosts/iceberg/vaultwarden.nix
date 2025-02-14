{
  config,
  lib,
  pkgs,
  ...
}: {
  containers.vaultwarden = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.7";
    localAddress = "192.168.100.8";
    bindMounts = {
      "/data" = {
        hostPath = "/persist/vaultwarden";
        isReadOnly = false;
      };
    };
    config = let
      hostConfig = config;
    in
      {
        config,
        pkgs,
        ...
      }: {
        networking.useHostResolvConf = false;
        system.stateVersion = "24.11";

        services.vaultwarden = {
          enable = true;
          backupDir = "/zfs/nyanbox/backup/vaultwarden";
          environmentFile = "/var/lib/bitwarden_rs/vaultwarden.env";
          config = {
            SIGNUPS_ALLOWED = true;
            ROCKET_PORT = 8066;
            DOMAIN = "https://vault.spicanet.duckdns.org";
            WEBSOCKET_ENABLED = true;
          };
        };
      };
  };
}
