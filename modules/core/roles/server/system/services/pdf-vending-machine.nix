{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.modules.system.services.pdf-vending-machine;
  hostAddress = "192.168.100.29";
  localAddress = "192.168.100.30";
  port = 3000;
  contentRoot = "/srv/pdf-vending-machine/content";
in {
  config = lib.mkIf cfg.enable {
    containers.pdf-vending-machine = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = hostAddress;
      localAddress = localAddress;
      bindMounts = {
        "${contentRoot}" = {
          hostPath = "/persist/files";
          isReadOnly = true;
        };
        "${config.age.secrets.pdf-vending-machine-content-id-secret.path}".isReadOnly = true;
      };
      config = let
        hostConfig = config;
      in
        {
          config,
          pkgs,
          lib,
          ...
        }: {
          imports = [
            inputs.pdf-vending-machine.nixosModules.default
          ];

          networking.useHostResolvConf = lib.mkForce false;
          services.resolved.enable = true;
          system.stateVersion = "26.05";
          networking.enableIPv6 = false;

          services.pdf-vending-machine = {
            enable = true;
            package = inputs.pdf-vending-machine.packages.${pkgs.system}.default;
            contentRoot = contentRoot;
            host = "0.0.0.0";
            inherit port;
            openFirewall = true;
          };

          systemd.services.pdf-vending-machine.serviceConfig.EnvironmentFile =
            hostConfig.age.secrets.pdf-vending-machine-content-id-secret.path;

          users.users.pdf-vending-machine.uid = hostConfig.users.users.files.uid;
          users.groups.pdf-vending-machine.gid = hostConfig.users.groups.files.gid;
        };
    };
  };
}
