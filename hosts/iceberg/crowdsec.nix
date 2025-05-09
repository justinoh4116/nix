{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  age.secrets.crowdsec-enroll-key.file = ../../secrets/crowdsec-enroll-key.age;

  containers.crowdsec = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.13";
    localAddress = "192.168.100.14";
    bindMounts = {
      "${config.age.secrets.nextcloud-admin-password.path}".isReadOnly = true;
    };
    config = let
      hostConfig = config;
    in
      {
        config,
        pkgs,
        crowdsec,
        ...
      }: {
        networking.useHostResolvConf = lib.mkForce false;
        networking.enableIPv6 = false;
        services.resolved.enable = true;
        system.stateVersion = "24.11";

        imports = [inputs.crowdsec.nixosModules.crowdsec];

        services.crowdsec = {
          enable = true;
          enrollKeyFile = "/run/agenix/crowdsec-enroll-key";
          settings = {
            api.server = {
              listen_uri = "127.0.0.1:8080";
            };
          };
        };
      };
  };
}
