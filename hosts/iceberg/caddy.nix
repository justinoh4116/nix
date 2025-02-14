{
  config,
  lib,
  pkgs,
  ...
}: {
  containers.caddy = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.3";
    localAddress = "192.168.100.4";
    bindMounts = {
    };
    config = let
      hostConfig = config;
    in
      {
        config,
        pkgs,
        ...
      }: {
        networking.useHostResolvConf = false;
        system.stateVersion = "24.11";

        services.caddy = {
          enable = true;
          virtualHosts."photos.spicanet.duckdns.org".extraConfig = ''
            reverse_proxy https://192.168.0.6:2283
          '';
        };
      };
  };
}
