{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.system.services.media-server;
in
{
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
      config =
        let
          hostConfig = config;
        in
        {
          config,
          pkgs,
          ...
        }:
        {
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
        };
    };
  };
}
