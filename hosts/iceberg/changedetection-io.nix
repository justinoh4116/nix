{
  config,
  lib,
  pkgs,
  ...
}: {
  age.secrets.paperless-admin-password.file = ../../secrets/paperless-admin-password.age;

  containers.changedetection-io = {
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

        services.changedetection-io = {
          enable = true;
          behindProxy = true;
        };

        networking.firewall.allowedTCPPorts = [
         5000
        ];
      };
  };
}
