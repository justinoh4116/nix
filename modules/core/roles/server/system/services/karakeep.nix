{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.system.services.karakeep;
in {
  config = lib.mkIf cfg.enable {
    containers.karakeep = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.100.25";
      localAddress = "192.168.100.26";
      bindMounts = {
        "/var/lib/karakeep" = {
          hostPath = "/persist/karakeep";
          isReadOnly = false;
        };
        "${config.age.secrets.gemini-karakeep-key.path}".isReadOnly = true;
      };
      config = {
        config,
        pkgs,
        lib,
        ...
      }: {
        networking.useHostResolvConf = lib.mkForce false;
        services.resolved.enable = true;
        system.stateVersion = "26.05";
        networking.enableIPv6 = false;

        networking.firewall.enable = false;

        services.karakeep = {
          enable = true;
          extraEnvironment = {
            HOSTNAME = "0.0.0.0";
            NEXTAUTH_URL = "https://keep.justinoh.io";
            OPENAI_BASE_URL = "https://generativelanguage.googleapis.com/v1beta";
            INFERENCE_TEXT_MODEL = "gemini-2.5-flash-lite";
            INFERENCE_IMAGE_MODEL = "gemini-2.5-flash-lite";
            DISABLE_SIGNUPS = "true";
          };
          environmentFile = "/run/agenix/gemini-karakeep-key";
        };

        networking.firewall.allowedTCPPorts = [3000];
      };
    };
  };
}
