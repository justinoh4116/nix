{
  config,
  lib,
  pkgs,
  ...
}: {
  services.caddy = {
    enable = true;
    virtualHosts."photos.spicanet.duckdns.org".extraConfig = ''
      reverse_proxy 192.168.0.5:2283
    '';
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
