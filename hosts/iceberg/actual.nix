{
  config,
  lib,
  pkgs,
  ...
}: {
  containers.actual = {
    autoStart = true;
    ephemeral = true;
    privateNetwork = true;
    hostAddress = "192.168.100.17";
    localAddress = "192.168.100.18";
    bindMounts = {
      "/var/lib/actual" = {
        hostPath = "/persist/actual";
        isReadOnly = false;
      };

      "/var/lib/smbphotolib" = {
        hostPath = "/persist/shares/private/photos";
        isReadOnly = false;
      };
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

        services.actual = {
          enable = true;
          settings = {
            hostname = "localhost";
          };
          openFirewall = true;
        };
      };
  };
}
