{
  config,
  lib,
  pkgs,
  ...
}: {
  age.secrets.paperless-admin-password.file = ../../secrets/paperless-admin-password.age;

  containers.paperless = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.13";
    localAddress = "192.168.100.14";
    bindMounts = {
      "${config.age.secrets.paperless-admin-password.path}".isReadOnly = true;
    };
    config = let
      hostConfig = config;
    in
      {
        config,
        pkgs,
        ...
      }: {
        networking.useHostResolvConf = lib.mkForce false;
        system.stateVersion = "24.11";

        services.paperless = {
          # port = 28981;
          enable = true;
          address = "192.168.100.14";
          # consumptionDirIsPublic = true;
          passwordFile = "/run/agenix/paperless-admin-password";
          settings = {
            PAPERLESS_URL = "https://paperless.justinoh.io";
            PAPERLESS_CONSUMER_IGNORE_PATTERN = [
              ".DS_STORE/*"
              "desktop.ini"
            ];
            PAPERLESS_OCR_LANGUAGE = "eng";
            PAPERLESS_OCR_USER_ARGS = {
              optimize = 1;
              pdfa_image_compression = "lossless";
            };
          };
        };

        networking.firewall.allowedTCPPorts = [
          28981
          8000
        ];
        networking.firewall.allowedUDPPorts = [
          28981
        ];
      };
  };
}
