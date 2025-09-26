{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.system.services.ddclient;
in {
  config = lib.mkIf cfg.enable {
    services.ddclient = {
      enable = true;
      configFile = "/etc/ddclient/ddclient.conf";
    };

    environment.etc = {
      "ddclient/ddclient.conf".text = ''
        cache=/var/lib/ddclient/ddclient.cache
        foreground=YES

        # Router
        usev4=webv4,webv4=ipify-ipv4

        # Protocol
        protocol=porkbun
        apikey=@porkbun-api-key@
        secretapikey=@porkbun-secret-key@
        root-domain=justinoh.io
        justinoh.io,*.justinoh.io
      '';
    };

    system.activationScripts."porkbun-secrets" = lib.stringAfter ["etc" "agenix"] ''
      apiKey=$(cat "${config.age.secrets."porkbun-api-key".path}")
      secretKey=$(cat "${config.age.secrets."porkbun-secret-key".path}")
      configDir=/etc/ddclient
      mkdir -p "$configDir"
      configFile=$configDir/ddclient.conf
      ${pkgs.gnused}/bin/sed -i "s#@porkbun-api-key@#$apiKey#" "$configFile"
      ${pkgs.gnused}/bin/sed -i "s#@porkbun-secret-key@#$secretKey#" "$configFile"
    '';
  };
}
