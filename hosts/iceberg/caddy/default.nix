{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  services.caddy = {
    enable = true;
    # package = inputs.caddy-patched.packages.${pkgs.system}.caddy;
    # package = pkgs.caddy.withPlugins {
    #   #   # plugins = ["github.com/caddy-dns/porkbun@v0.3.0"];
    #   plugins = ["github.com/hslatman/caddy-crowdsec-bouncer@v0.8.1"];
    #   #   # hash = pkgs.lib.fakeHash;
    #   hash = "sha256-3kB4w5/J0Jrt4Cw17GcsVZJueBMmJSEgLrBAw5qmS64=";
    # };
    configFile = ./Caddyfile;
    # virtualHosts."photos.justinoh.io".extraConfig = ''
    #   reverse_proxy http://192.168.100.6:2283
    # '';
    #
    # virtualHosts."files.justinoh.io".extraConfig = ''
    #   reverse_proxy http://192.168.100.8:80
    # '';
    #
    # virtualHosts."changedetection.justinoh.io".extraConfig = ''
    #   reverse_proxy http://192.168.100.12:5000
    # '';
    #
    # virtualHosts."vault.justinoh.io".extraConfig = ''
    #   reverse_proxy http://localhost:8222
    # '';
    #
    # virtualHosts."paperless.justinoh.io".extraConfig = ''
    #     reverse_proxy http://192.168.100.14:28981 {
    #       header_down Referrer-Policy "strict-origin-when-cross-origin"
    #   }
    # '';
    # extraConfig = ''
    # {
    #   acme_dns porkbun {
    #     api_key @porkbun-api-key@
    #     api_secret_key @porkbun-secret-key@
    #   }
    # }
    # '';
  };

  system.activationScripts."caddy-secrets" = lib.stringAfter ["etc" "agenix"] ''
    apiKey=$(cat "${config.age.secrets."porkbun-api-key".path}")
    secretKey=$(cat "${config.age.secrets."porkbun-secret-key".path}")
    crowdsecBouncerKey=$(cat "${config.age.secrets."crowdsec-caddy-bouncer-key".path}")
    configDir=/etc/caddy
    mkdir -p "$configDir"
    configFile=$configDir/caddy_config
    ${pkgs.gnused}/bin/sed -i "s#@porkbun-api-key@#$apiKey#" "$configFile"
    ${pkgs.gnused}/bin/sed -i "s#@porkbun-secret-key@#$secretKey#" "$configFile"
    ${pkgs.gnused}/bin/sed -i "s#@crowdsec-caddy-bouncer-key@#$crowdsecBouncerKey#" "$configFile"
  '';

  age.secrets.porkbun-api-key.file = ../../../secrets/porkbun-api-key.age;
  age.secrets.porkbun-secret-key.file = ../../../secrets/porkbun-secret-key.age;
  age.secrets.crowdsec-caddy-bouncer-key.file = ../../../secrets/crowdsec-caddy-bouncer-key.age;

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
