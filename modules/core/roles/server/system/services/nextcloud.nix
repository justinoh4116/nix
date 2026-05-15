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

        "/etc/resolv.conf" = {
          hostPath = "/etc/resolv.conf";
          isReadOnly = true;
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
          # networking.useHostResolvConf = lib.mkForce false;
          networking.useHostResolvConf = true;
          # services.resolved.enable = true;
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
            package = pkgs.nextcloud33;
            # Instead of using pkgs.nextcloud28Packages.apps,
            # we'll reference the package version specified above
            # extraApps = {
            #   inherit (config.services.nextcloud.package.packages.apps) ext;
            # };
            extraAppsEnable = true;
          };
          networking.firewall.allowedTCPPorts = [80];

          users.users.nextcloud.uid = hostConfig.users.users.files.uid;
          users.groups.nextcloud.gid = hostConfig.users.groups.files.gid;
        };
    };

    users.users.files.uid = 967;
    users.users.files.group = "files";
    users.groups.files.gid = 967;
  };
}
