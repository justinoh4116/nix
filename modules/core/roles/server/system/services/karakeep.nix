{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.system.services.karakeep;
in {
  config = lib.mkIf cfg.enable {
    containers.karakeep = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.100.25";
      localAddress = "192.168.100.26";
      bindMounts = {
        "/var/lib/karakeep" = {
          hostPath = "/persist/karakeep/data";
          isReadOnly = false;
        };
        "/var/lib/meilisearch" = {
          hostPath = "/persist/karakeep/meilisearch";
          isReadOnly = false;
        };
      };
      config = {
        config,
        pkgs,
        lib,
        ...
      }: {
        networking.useHostResolvConf = lib.mkForce false;
        services.resolved.enable = true;
        system.stateVersion = "24.11";

        services.karakeep = {
          enable = true;
          extraEnvironment = {
            HOSTNAME = "0.0.0.0";
            NEXTAUTH_URL = "httpps://keep.justinoh.io";
            OPENAI_API_KEY = "";
          };
        };

        networking.firewall.allowedTCPPorts = [3000];
      };
    };
  };
}
