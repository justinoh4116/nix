{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.system.services.vaultwarden;
in {
  config = lib.mkIf cfg.enable {
    services.vaultwarden = {
      enable = true;
      backupDir = "/persist/vaultwarden_backup";
      #environmentFile = "/var/lib/bitwarden_rs/vaultwarden.env";
      config = {
        SIGNUPS_ALLOWED = true;
        ROCKET_PORT = 8222;
        DOMAIN = "https://vault.justinoh.io";
        WEBSOCKET_ENABLED = true;
      };
    };

    networking.firewall.allowedTCPPorts = [8222];
  };
}
