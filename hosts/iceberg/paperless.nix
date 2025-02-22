{
  config,
  lib,
  pkgs,
  ...
}: {
  age.secrets.paperless-admin-password.file = ../../secrets/paperless-admin-password.age;

  containers.immich = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.11";
    localAddress = "192.168.100.12";
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
          enable = true;
          # consumptionDirIsPublic = true;
          address = "paperless.spicanet.duckdns.org";
          passwordFile = "/run/agenix/paperless-admin-password";
          settings = {
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
        ];
      };
  };
}
