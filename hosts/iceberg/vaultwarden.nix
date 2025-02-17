{
  config,
  lib,
  pkgs,
  ...
}: {
  services.vaultwarden = {
    enable = true;
    backupDir = "/persist/vaultwarden_backup";
    #environmentFile = "/var/lib/bitwarden_rs/vaultwarden.env";
    config = {
      SIGNUPS_ALLOWED = false;
      ROCKET_PORT = 8222;
      DOMAIN = "https://vault.spicanet.duckdns.org";
      WEBSOCKET_ENABLED = true;
    };
  };
}
