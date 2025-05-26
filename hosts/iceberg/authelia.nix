{
  config,
  lib,
  pkgs,
  ...
}: {
  age.secrets.authelia-jwt-secret = {
    file = ../../secrets/authelia-jwt-secret.age;
    owner = "authelia";
    group = "authelia";
    mode = "770";
  };
  age.secrets.authelia-session-secret = {
    file = ../../secrets/authelia-session-secret.age;
    owner = "authelia";
    group = "authelia";
    mode = "770";
  };
  age.secrets.authelia-storage-encryption-key = {
    file = ../../secrets/authelia-storage-encryption-key.age;
    owner = "authelia";
    group = "authelia";
    mode = "770";
  };

  users.users.authelia.uid = 943;
  users.users.authelia.group = "authelia";
  users.groups.authelia.gid = 943;

  containers.authelia = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.15";
    localAddress = "192.168.100.16";
    bindMounts = {
      "${config.age.secrets.authelia-jwt-secret.path}".isReadOnly = true;
      "${config.age.secrets.authelia-session-secret.path}".isReadOnly = true;
      "${config.age.secrets.authelia-storage-encryption-key.path}".isReadOnly = true;
      "/var/lib/authelia" = {
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
        networking.useHostResolvConf = lib.mkForce false;
        system.stateVersion = "24.11";

        networking.firewall.allowedTCPPorts = [9091];

        services.authelia.instances = {
          main = {
            enable = true;
            user = "authelia";
            group = "authelia";
            secrets = {
              jwtSecretFile = "/run/agenix/authelia-jwt-secret";
              sessionSecretFile = "/run/agenix/authelia-session-secret";
              storageEncryptionKeyFile = "/run/agenix/authelia-storage-encryption-key";
            };
            settings = {
              theme = "auto";
              default_2fa_method = "totp";
              log.level = "debug";
              totp.issuer = "authelia.com";
              storage.local.path = "/var/lib/authelia/db.sqlite3";
              access_control = {
                default_policy = "two_factor";
              };
              server = {
                disable_healthcheck = true;
                endpoints.authz.forward-auth.implementation = "ForwardAuth";
              };
              session = {
                domain = "justinoh.io";
                cookies = {
                  # authelia_url = "https://auth.justinoh.io";
                  # default_redirection_url = "https://justinoh.io";
                };
                redis = {
                  host = "127.0.0.1";
                };
              };
              notifier = {
                filesystem.filename = "/var/lib/authelia/notification.txt";
              };
              authentication_backend.file.path = "/var/lib/authelia/users_database.yml";
            };
          };
        };
        services.redis.servers."redis-authelia" = {
          openFirewall = true;
          enable = true;
          port = 6379;
        };

        users.users.authelia.uid = hostConfig.users.users.authelia.uid;
        users.users.authelia.group = "authelia";
        users.groups.authelia.gid = hostConfig.users.groups.authelia.gid;
      };
  };
}
