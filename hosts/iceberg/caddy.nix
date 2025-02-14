{
  config,
  lib,
  pkgs,
  ...
}: {
  services.caddy = {
    enable = true;
    virtualHosts."photos.spicanet.duckdns.org".extraConfig = ''
      reverse_proxy http://192.168.100.6:2283
    '';
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
