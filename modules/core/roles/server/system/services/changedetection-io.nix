{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.system.services.changedetection-io;
in {
  config = lib.mkIf cfg.enable {
    containers.changedetection-io = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.100.11";
      localAddress = "192.168.100.12";
      bindMounts = {
        "/var/lib/changedetection-io" = {
          hostPath = "/persist/changedetection-io";
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
          services.resolved.enable = true;
          system.stateVersion = "24.11";

          services.changedetection-io = {
            enable = true;
            listenAddress = "192.168.100.12";
            behindProxy = true;
            # baseURL = "https://changedetection.spicanet.duckdns.org";
          };

          networking.firewall.allowedTCPPorts = [
            5000
          ];
        };
    };
  };
}
