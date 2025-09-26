{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.system.services.nextcloud;
in {
  config = lib.mkIf cfg.enable {
    containers.nextcloud = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.100.7";
      localAddress = "192.168.100.8";
      bindMounts = {
        "${config.age.secrets.nextcloud-admin-password.path}".isReadOnly = true;

        "/var/lib/nextcloud" = {
          hostPath = "/persist/nextcloud";
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
          networking.useHostResolvConf = lib.mkForce false;
          networking.enableIPv6 = false;
          services.resolved.enable = true;
          system.stateVersion = "24.11";

          services.nextcloud = {
            enable = true;
            hostName = "localhost";
            home = "/var/lib/nextcloud";
            # domain = "files.spicanet.duckdns.org";
            settings = {
              trusted_domains = ["files.spicanet.duckdns.org" "files.justinoh.io"];
              overwriteprotocol = "https";
            };
            config.adminpassFile = "/run/agenix/nextcloud-admin-password";
            config.dbtype = "sqlite";
            package = pkgs.nextcloud31;
            # Instead of using pkgs.nextcloud28Packages.apps,
            # we'll reference the package version specified above
            extraApps = {
              # inherit (config.services.nextcloud.package.packages.apps) news contacts calendar tasks;
            };
            extraAppsEnable = true;
          };
          networking.firewall.allowedTCPPorts = [80];
        };
    };
  };
}
