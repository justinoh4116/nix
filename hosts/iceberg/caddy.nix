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

    virtualHosts."vault.spicanet.duckdns.org".extraConfig = ''
      reverse_proxy http://localhost:8222
    '';

    virtualHosts."paperless.spicanet.duckdns.org".extraConfig = ''
      reverse_proxy http://192.168.100.14:28981 {
        header_down Referrer-Policy "strict-origin-when-cross-origin"
    }
    '';
  };

  # services.duckdns = {
  #   enable = true;
  #   domains = ["spicanet"];
  #   tokenFile = config.age.secrets.duckdns.path;
  # };

  age.secrets.duckdns.file = ../../secrets/tailscale-auth.age;

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
