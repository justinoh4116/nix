{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.system.services.media-server;
in {
  config = lib.mkIf cfg.enable {
    containers.media-servicea = {
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
      extraFlags = [
        # These extra flags are required for docker usage
        "--system-call-filter=keyctl"
        "--system-call-filter=bpf"
      ];
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

          networking.firewall.enable = false;

          virtualisation.docker.enable = true;
          environment.systemPackages = with pkgs; [
            docker
            docker-compose
          ];
          networking.firewall.allowedTCPPorts = [
            # 5000
            5055
          ];

          # # Runtime
          # virtualisation.podman = {
          #   enable = true;
          #   autoPrune.enable = true;
          #   dockerCompat = true;
          # };
          #
          # # Enable container name DNS for all Podman networks.
          # networking.firewall.interfaces = let
          #   matchAll =
          #     if !config.networking.nftables.enable
          #     then "podman+"
          #     else "podman*";
          # in {
          #   "${matchAll}".allowedUDPPorts = [53];
          # };
          #
          # virtualisation.oci-containers.backend = "podman";
          #
          # # Containers
          # virtualisation.oci-containers.containers."bazarr" = {
          #   image = "ghcr.io/hotio/bazarr:latest";
          #   environment = {
          #     "PGID" = "1000";
          #     "PUID" = "1000";
          #     "TZ" = "US/Pacific";
          #   };
          #   volumes = [
          #     "/config/bazarr:/config:rw"
          #     "/data/media:/data/media:rw"
          #     "/etc/localtime:/etc/localtime:ro"
          #   ];
          #   ports = [
          #     "6767:6767/tcp"
          #   ];
          #   log-driver = "journald";
          #   extraOptions = [
          #     "--hostname=bazarr.internal"
          #     "--network-alias=bazarr"
          #     "--network=media-services_default"
          #   ];
          # };
          # systemd.services."podman-bazarr" = {
          #   serviceConfig = {
          #     Restart = lib.mkOverride 90 "always";
          #   };
          #   after = [
          #     "podman-network-media-services_default.service"
          #   ];
          #   requires = [
          #     "podman-network-media-services_default.service"
          #   ];
          #   partOf = [
          #     "podman-compose-media-services-root.target"
          #   ];
          #   wantedBy = [
          #     "podman-compose-media-services-root.target"
          #   ];
          # };
          # virtualisation.oci-containers.containers."jellyfin" = {
          #   image = "jellyfin/jellyfin";
          #   volumes = [
          #     "/config/jellycache:/cache:rw"
          #     "/config/jellyfin:/config:rw"
          #     "/data/media:/media:rw"
          #   ];
          #   ports = [
          #     "8096:8096/tcp"
          #     "7359:7359/udp"
          #   ];
          #   user = "1000:1000";
          #   log-driver = "journald";
          #   extraOptions = [
          #     "--add-host=host.docker.internal:host-gateway"
          #     "--network-alias=jellyfin"
          #     "--network=media-services_default"
          #   ];
          # };
          # systemd.services."podman-jellyfin" = {
          #   serviceConfig = {
          #     Restart = lib.mkOverride 90 "always";
          #   };
          #   after = [
          #     "podman-network-media-services_default.service"
          #   ];
          #   requires = [
          #     "podman-network-media-services_default.service"
          #   ];
          #   partOf = [
          #     "podman-compose-media-services-root.target"
          #   ];
          #   wantedBy = [
          #     "podman-compose-media-services-root.target"
          #   ];
          # };
          # virtualisation.oci-containers.containers."prowlarr" = {
          #   image = "ghcr.io/hotio/prowlarr";
          #   environment = {
          #     "PGID" = "1000";
          #     "PUID" = "1000";
          #     "TZ" = "US/Pacific";
          #     "UMASK" = "002";
          #     "WEBUI_PORTS" = "9696/tcp";
          #   };
          #   volumes = [
          #     "/config/prowlarr:/config:rw"
          #   ];
          #   ports = [
          #     "9696:9696/tcp"
          #   ];
          #   user = "1000:1000";
          #   log-driver = "journald";
          #   extraOptions = [
          #     "--network-alias=prowlarr"
          #     "--network=media-services_default"
          #   ];
          # };
          # systemd.services."podman-prowlarr" = {
          #   serviceConfig = {
          #     Restart = lib.mkOverride 90 "no";
          #   };
          #   after = [
          #     "podman-network-media-services_default.service"
          #   ];
          #   requires = [
          #     "podman-network-media-services_default.service"
          #   ];
          #   partOf = [
          #     "podman-compose-media-services-root.target"
          #   ];
          #   wantedBy = [
          #     "podman-compose-media-services-root.target"
          #   ];
          # };
          # virtualisation.oci-containers.containers."radarr" = {
          #   image = "ghcr.io/hotio/radarr:latest";
          #   environment = {
          #     "PGID" = "1000";
          #     "PUID" = "1000";
          #     "TZ" = "US/Pacific";
          #   };
          #   volumes = [
          #     "/config/radarr:/config:rw"
          #     "/data:/data:rw"
          #     "/etc/localtime:/etc/localtime:ro"
          #   ];
          #   ports = [
          #     "7878:7878/tcp"
          #   ];
          #   log-driver = "journald";
          #   extraOptions = [
          #     "--hostname=radarr.internal"
          #     "--network-alias=radarr"
          #     "--network=media-services_default"
          #   ];
          # };
          # systemd.services."podman-radarr" = {
          #   serviceConfig = {
          #     Restart = lib.mkOverride 90 "always";
          #   };
          #   after = [
          #     "podman-network-media-services_default.service"
          #   ];
          #   requires = [
          #     "podman-network-media-services_default.service"
          #   ];
          #   partOf = [
          #     "podman-compose-media-services-root.target"
          #   ];
          #   wantedBy = [
          #     "podman-compose-media-services-root.target"
          #   ];
          # };
          # virtualisation.oci-containers.containers."sabnzbd" = {
          #   image = "ghcr.io/hotio/sabnzbd:latest";
          #   environment = {
          #     "PGID" = "1000";
          #     "PUID" = "1000";
          #     "TZ" = "US/Pacific";
          #   };
          #   volumes = [
          #     "/config/sabnzbd:/config:rw"
          #     "/data/usenet:/data/usenet:rw"
          #     "/etc/localtime:/etc/localtime:ro"
          #   ];
          #   ports = [
          #     "8080:8080/tcp"
          #     "9090:9090/tcp"
          #   ];
          #   log-driver = "journald";
          #   extraOptions = [
          #     "--hostname=sabnzbd.internal"
          #     "--network-alias=sabnzbd"
          #     "--network=media-services_default"
          #   ];
          # };
          # systemd.services."podman-sabnzbd" = {
          #   serviceConfig = {
          #     Restart = lib.mkOverride 90 "always";
          #   };
          #   after = [
          #     "podman-network-media-services_default.service"
          #   ];
          #   requires = [
          #     "podman-network-media-services_default.service"
          #   ];
          #   partOf = [
          #     "podman-compose-media-services-root.target"
          #   ];
          #   wantedBy = [
          #     "podman-compose-media-services-root.target"
          #   ];
          # };
          # virtualisation.oci-containers.containers."seerr" = {
          #   image = "ghcr.io/seerr-team/seerr:latest";
          #   environment = {
          #     "LOG_LEVEL" = "debug";
          #     "PORT" = "5055";
          #     "TZ" = "US/Pacific";
          #   };
          #   volumes = [
          #     "/config/seerr:/app/config:rw"
          #   ];
          #   ports = [
          #     "5055:5055/tcp"
          #   ];
          #   log-driver = "journald";
          #   extraOptions = [
          #     "--health-cmd=wget --no-verbose --tries=1 --spider http://localhost:5055/api/v1/settings/public || exit 1"
          #     "--health-interval=15s"
          #     "--health-retries=3"
          #     "--health-start-period=20s"
          #     "--health-timeout=3s"
          #     "--init=true"
          #     "--network-alias=seerr"
          #     "--network=media-services_default"
          #   ];
          # };
          # systemd.services."podman-seerr" = {
          #   serviceConfig = {
          #     Restart = lib.mkOverride 90 "always";
          #   };
          #   after = [
          #     "podman-network-media-services_default.service"
          #   ];
          #   requires = [
          #     "podman-network-media-services_default.service"
          #   ];
          #   partOf = [
          #     "podman-compose-media-services-root.target"
          #   ];
          #   wantedBy = [
          #     "podman-compose-media-services-root.target"
          #   ];
          # };
          # virtualisation.oci-containers.containers."sonarr" = {
          #   image = "ghcr.io/hotio/sonarr:latest";
          #   environment = {
          #     "PGID" = "1000";
          #     "PUID" = "1000";
          #     "TZ" = "US/Pacific";
          #   };
          #   volumes = [
          #     "/config/sonarr:/config:rw"
          #     "/data:/data:rw"
          #     "/etc/localtime:/etc/localtime:ro"
          #   ];
          #   ports = [
          #     "8989:8989/tcp"
          #   ];
          #   log-driver = "journald";
          #   extraOptions = [
          #     "--hostname=sonarr.internal"
          #     "--network-alias=sonarr"
          #     "--network=media-services_default"
          #   ];
          # };
          # systemd.services."podman-sonarr" = {
          #   serviceConfig = {
          #     Restart = lib.mkOverride 90 "always";
          #   };
          #   after = [
          #     "podman-network-media-services_default.service"
          #   ];
          #   requires = [
          #     "podman-network-media-services_default.service"
          #   ];
          #   partOf = [
          #     "podman-compose-media-services-root.target"
          #   ];
          #   wantedBy = [
          #     "podman-compose-media-services-root.target"
          #   ];
          # };
          #
          # # Networks
          # systemd.services."podman-network-media-services_default" = {
          #   path = [pkgs.podman];
          #   serviceConfig = {
          #     Type = "oneshot";
          #     RemainAfterExit = true;
          #     ExecStop = "podman network rm -f media-services_default";
          #   };
          #   script = ''
          #     podman network inspect media-services_default || podman network create media-services_default
          #   '';
          #   partOf = ["podman-compose-media-services-root.target"];
          #   wantedBy = ["podman-compose-media-services-root.target"];
          # };
          #
          # # Root service
          # # When started, this will automatically create all resources and start
          # # the containers. When stopped, this will teardown all resources.
          # systemd.targets."podman-compose-media-services-root" = {
          #   unitConfig = {
          #     Description = "Root target generated by compose2nix.";
          #   };
          #   wantedBy = ["multi-user.target"];
          # };
        };
    };
  };
}
