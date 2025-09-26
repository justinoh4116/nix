{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.system.services.authelia;
in {
  config = lib.mkIf cfg.enable {
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
            file = ../../../../../../../secrets/authelia-jwt-secret.age;
            owner = "authelia-main";
            group = "authelia-main";
            mode = "770";
          };
          age.secrets.authelia-session-secret = {
            file = ../../../../../../../secrets/authelia-session-secret.age;
            owner = "authelia-main";
            group = "authelia-main";
            mode = "770";
          };
          age.secrets.authelia-storage-encryption-key = {
            file = ../../../../../../../secrets/authelia-storage-encryption-key.age;
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
                # identity_providers = {
                #   oidc = {
                #     clients = [
                #       {
                #         client_id = "qkvY.4qcwT1MtlufSxxzASp8T-Mt_lZz_AASmvrBShkrxsYgAhYXJXk3Xs4nO8u0z2oLzB1g";
                #         client_name = "Paperless";
                #         client_secret = "$pbkdf2-sha512$310000$buYoXiaaYlLCjHqwr5sJUg$l36cG1Secz1VL2RkdblSqpBscb2tucqTCfJfqV8T.f4I0REmXINhA5dD0AoLovvrGCrJUwvlcnCjP7D3NiaaeA";
                #         public = false;
                #         authorization_policy = "two_factor";
                #         require_pkce = true;
                #         pkce_challenge_method = "S256";
                #         redirect_uris = [
                #           "https://paperless.justinoh.io/accounts/oidc/authelia/login/callback/"
                #         ];
                #         scopes = [
                #           "openid"
                #           "profile"
                #           "email"
                #           "groups"
                #         ];
                #         user_info_signed_response_alg = "none";
                #         token_endpoint_auth_method = "client_secret_basic";
                #       }
                #     ];
                #     hmac_secret = "{{- fileContent \"./test_resources/example_filter_rsa_private_key\"}}";
                #     jwks = [
                #       {
                #         key_id = "authelia";
                #         algorithm = "RS256";
                #         use = "sig";
                #         certificate_chain = "-----BEGIN CERTIFICATE-----\n<PASTE-HERE-YOUR-PUBLIC-KEY-DATA>\n-----END CERTIFICATE-----\n";
                #         key = "-----BEGIN PRIVATE KEY-----\n<PASTE-HERE-YOUR-PRIVATE-KEY-DATA>\n-----END PRIVATE KEY-----\n";
                #       }
                #     ];
                #     enable_client_debug_messages = false;
                #     minimum_parameter_entropy = 8;
                #     enforce_pkce = "public_clients_only";
                #     enable_pkce_plain_challenge = false;
                #     enable_jwt_access_token_stateless_introspection = false;
                #     discovery_signed_response_alg = "none";
                #     discovery_signed_response_key_id = "";
                #     require_pushed_authorization_requests = false;
                #     lifespans = {
                #       access_token = "1h";
                #       authorize_code = "1m";
                #       id_token = "1h";
                #       refresh_token = "90m";
                #     };
                #     cors = {
                #       endpoints = ["authorization" "token" "revocation" "introspection"];
                #       allowed_origins = ["https://immich.example.com"];
                #       allowed_origins_from_client_redirect_uris = false;
                #     };
                #   };
                # };
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
  };
}
