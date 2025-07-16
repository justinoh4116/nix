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
      "/var/lib/private/actual" = {
        hostPath = "/persist/actualprivate";
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
            # hostname = "localhost";
          };
          openFirewall = true;
        };
        users.users.actual.uid = hostConfig.users.users.actual.uid;
        users.groups.actual.gid = hostConfig.users.groups.actual.gid;
        users.users.actual.group = "actual";
      };
  };
  users.users.actual.uid = 986;
  users.users.actual.group = "actual";
  users.groups.actual.gid = 986;
}
