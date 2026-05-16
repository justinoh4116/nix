{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.modules.system.services.site;
  hostAddress = "192.168.100.27";
  localAddress = "192.168.100.28";
  port = 3000;
in {
  config = lib.mkIf cfg.enable {
    containers.site = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = hostAddress;
      localAddress = localAddress;
      config = {
        config,
        pkgs,
        lib,
        ...
      }: {
        imports = [
          inputs.personal-site.nixosModules.default
        ];

        networking.useHostResolvConf = lib.mkForce false;
        services.resolved.enable = true;
        system.stateVersion = "26.05";
        networking.enableIPv6 = false;

        services.site = {
          enable = true;
          host = "0.0.0.0";
          inherit port;
          openFirewall = true;
        };
      };
    };
  };
}
