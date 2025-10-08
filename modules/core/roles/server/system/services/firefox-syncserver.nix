{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  cfg = config.modules.system.services.firefox-syncserver;
in {
  config = lib.mkIf cfg.enable {
    containers.firefox-syncserver = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.100.20";
      localAddress = "192.168.100.21";
      bindMounts = {
        "/etc/ssh/ssh_host_ed25519_key".isReadOnly = true;
        # "${config.age.secrets.firefox-syncserver-secrets.path}" = {
        #   isReadOnly = true;
        # };
      };
      config = let
        hostConfig = config;
      in
        {
          config,
          pkgs,
          ...
        }: {
          imports = [inputs.agenix.nixosModules.default];
          age.identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];

          networking.useHostResolvConf = lib.mkForce false;
          services.resolved.enable = true;
          system.stateVersion = "25.11";

          age.secrets.firefox-syncserver-secrets = {
            file = ../../../../../../secrets/firefox-syncserver-secrets.age;
            owner = "firefox-syncserver";
            group = "firefox-syncserver";
            mode = "770";
          };

          services = {
            firefox-syncserver = {
              enable = true;
              secrets = config.age.secrets.firefox-syncserver-secrets.path;
              singleNode = {
                enable = true;
                url = "192.168.100.20";
              };
              settings = {
                port = 5000;
                tokenserver = {
                  enabled = true;
                };
              };
            };
            mysql.package = pkgs.mariadb;
          };

          networking.firewall.allowedTCPPorts = [
            5000
          ];
        };
    };
  };
}
