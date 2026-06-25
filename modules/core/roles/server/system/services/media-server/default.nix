{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.system.services.media-server;
  composeFile = ./docker-compose;
in {
  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [5055];

    containers.media-services = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.101.3";
      localAddress = "192.168.101.4";
      bindMounts = {
        "/data" = {
          hostPath = "/persist/media";
          isReadOnly = false;
        };
        # "/data" = {
        #   hostPath = "/data/media";
        #   isReadOnly = false;
        # };
        "/config" = {
          hostPath = "/persist/media-server-config";
          isReadOnly = false;
        };
      };
      extraFlags = [
        # These extra flags are required for docker usage
        "--system-call-filter=keyctl"
        "--system-call-filter=bpf"
      ];
      # forwardPorts = [
      #   {
      #     protocol = "tcp";
      #     hostPort = 5055;
      #     containerPort = 5055;
      #   }
      # ];
      config = {pkgs, ...}: {
        networking.useHostResolvConf = lib.mkForce false;
        # Private nspawn networking has no DHCP-provided resolver.
        networking.nameservers = [
          # "192.168.100.1"
          "1.1.1.1"
        ];
        services.resolved.enable = true;
        system.stateVersion = "26.05";
        networking.enableIPv6 = false;

        networking.firewall.enable = false;

        virtualisation.docker.enable = true;
        environment.systemPackages = with pkgs; [
          docker
          docker-compose
        ];

        systemd.services.media-server-compose = {
          description = "Media server Docker Compose stack";
          wantedBy = ["multi-user.target"];
          requires = ["docker.service"];
          wants = ["network-online.target"];
          after = [
            "docker.service"
            "network-online.target"
          ];
          restartTriggers = [composeFile];

          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${pkgs.docker-compose}/bin/docker-compose -p media-services -f ${composeFile} up -d --remove-orphans";
            ExecStop = "${pkgs.docker-compose}/bin/docker-compose -p media-services -f ${composeFile} down";
            ExecReload = "${pkgs.docker-compose}/bin/docker-compose -p media-services -f ${composeFile} up -d --remove-orphans";
            TimeoutStartSec = 0;
          };
        };

        networking.firewall.allowedTCPPorts = [
          # 5000
          5055
        ];
      };
    };
  };
}
