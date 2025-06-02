{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  users.users.authelia-main.uid = 943;
  users.users.authelia-main.group = "authelia-main";
  users.groups.authelia-main.gid = 943;

  containers.authelia = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.15";
    localAddress = "192.168.100.16";
    bindMounts = {
      # "${config.age.secrets.authelia-jwt-secret.path}".isReadOnly = true;
      # "${config.age.secrets.authelia-session-secret.path}".isReadOnly = true;
      # "${config.age.secrets.authelia-storage-encryption-key.path}".isReadOnly = true;
      "/etc/ssh/ssh_host_ed25519_key".isReadOnly = true;
      "/var/lib/authelia-main" = {
        hostPath = "/persist/authelia";
        isReadOnly = false;
      };
      "/var/lib/redis-redis-authelia" = {
        hostPath = "/persist/authelia/redis";
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
        imports = [inputs.agenix.nixosModules.default];

        networking.useHostResolvConf = lib.mkForce false;
        networking.enableIPv6 = false;
        services.resolved.enable = true;
        system.stateVersion = "24.11";

        age.identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];

        networking.firewall.allowedTCPPorts = [9091];

        age.secrets.authelia-jwt-secret = {
          file = ../../secrets/authelia-jwt-secret.age;
          owner = "authelia-main";
          group = "authelia-main";
          mode = "770";
        };
        age.secrets.authelia-session-secret = {
          file = ../../secrets/authelia-session-secret.age;
          owner = "authelia-main";
          group = "authelia-main";
          mode = "770";
        };
        age.secrets.authelia-storage-encryption-key = {
          file = ../../secrets/authelia-storage-encryption-key.age;
          owner = "authelia-main";
          group = "authelia-main";
          mode = "770";
        };

        environment.etc."authelia-main/config.yml".source = ./authelia.yml;

        services.authelia.instances = {
          main = {
            enable = true;
            # user = "authelia";
            # group = "authelia";
            secrets = {
              jwtSecretFile = "/run/agenix/authelia-jwt-secret";
              sessionSecretFile = "/run/agenix/authelia-session-secret";
              storageEncryptionKeyFile = "/run/agenix/authelia-storage-encryption-key";
            };
            settingsFiles = ["/etc/authelia-main/config.yml"];
            settings = {
              theme = "auto";
              default_2fa_method = "totp";
              log.level = "debug";
              log.file_path = "/var/lib/authelia-main/authelia.log";
              totp.issuer = "authelia.com";
              storage.local.path = "/var/lib/authelia-main/db.sqlite3";
              access_control = {
                default_policy = "two_factor";
              };
              server = {
                disable_healthcheck = true;
                endpoints.authz.forward-auth.implementation = "ForwardAuth";
              };
              session = {
                redis = {
                  host = "127.0.0.1";
                };
              };
              notifier = {
                filesystem.filename = "/var/lib/authelia-main/notification.txt";
              };
              authentication_backend.file.path = "/var/lib/authelia-main/users_database.yml";
            };
          };
        };
        services.redis.servers."redis-authelia" = {
          openFirewall = true;
          enable = true;
          port = 6379;
        };

        users.users.authelia-main.uid = hostConfig.users.users.authelia-main.uid;
        users.users.authelia-main.group = "authelia-main";
        users.groups.authelia-main.gid = hostConfig.users.groups.authelia-main.gid;
      };
  };
}
