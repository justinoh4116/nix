{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.system.services.media-server;
in {
  config = lib.mkIf cfg.enable {
    containers.media-services = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.100.23";
      localAddress = "192.168.100.24";
      bindMounts = {
        "/data" = {
          hostPath = "/persist/media";
          isReadOnly = false;
        };
        "/config" = {
          hostPath = "/persist/media-server-config";
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
          system.stateVersion = "26.05";

          environment.etc."docker-compose".source = ./docker-compose;

          virtualisation.docker = {
            enable = true;
          };

          environment.systemPackages = with pkgs; [
            docker-compose
          ];

          networking.firewall.allowedTCPPorts = [
            # 5000
          ];
        };
    };
  };
}
