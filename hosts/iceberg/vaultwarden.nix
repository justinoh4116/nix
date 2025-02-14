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
          #backupDir = "/zfs/nyanbox/backup/vaultwarden";
          #environmentFile = "/var/lib/bitwarden_rs/vaultwarden.env";
          config = {
            DATA_FOLDER = "/data";
            SIGNUPS_ALLOWED = true;
            ROCKET_PORT = 8222;
            DOMAIN = "vault.spicanet.duckdns.org";
            WEBSOCKET_ENABLED = true;
          };
        };

        networking.firewall.allowedTCPPorts = [8222];
        networking.firewall.allowedUDPPorts = [8222];
      };
  };
}
