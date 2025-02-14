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

  services.duckdns = {
    enable = true;
    domains = ["spicanet"];
    tokenFile = config.age.secrets.duckdns.path;
  };

  age.secrets.duckdns.file = ../../secrets/tailscale-auth.age;

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
