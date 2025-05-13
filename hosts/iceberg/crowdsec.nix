{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  age.secrets.crowdsec-enroll-key = {
    file = ../../secrets/crowdsec-enroll-key.age;
    owner = "crowdsec";
    group = "crowdsec";
    mode = "770";
  };

  age.secrets.crowdsec-firewall-bouncer-key.file = ../../secrets/crowdsec-firewall-bouncer-key.age;

  imports = [inputs.crowdsec.nixosModules.crowdsec inputs.crowdsec.nixosModules.crowdsec-firewall-bouncer];

  nixpkgs.overlays = [inputs.crowdsec.overlays.default];

  services = {
    crowdsec = {
      package = inputs.crowdsec.packages.${pkgs.system}.crowdsec;
      enable = true;
      enrollKeyFile = config.age.secrets.crowdsec-enroll-key.path;
      settings = {
        api.server = {
          listen_uri = "127.0.0.1:8081";
        };
      };
    };

    crowdsec-firewall-bouncer = {
      package = inputs.crowdsec.packages.${pkgs.system}.crowdsec-firewall-bouncer;
      enable = true;
      settings = {
        api_key = "\${FIREWALL_KEY}";
        api_url = "http://localhost:8081";
      };
    };
  };
  systemd.services.crowdsec.serviceConfig = {
    ExecStartPre = let
      script = pkgs.writeScriptBin "register-bouncer" ''
        #!${pkgs.runtimeShell}
        set -eu
        set -o pipefail

        if ! cscli bouncers list | grep -q "iceberg-firewall"; then
          cscli bouncers add "iceberg-firewall" --key "''${cat ${config.age.secrets.crowdsec-firewall-bouncer-key.file} | ${pkgs.gnused}/bin/sed "s/FIREWALL_KEY=//"}"
        fi
      '';
    in ["${script}/bin/register-bouncer"];
  };

  systemd.services.crowdsec-firewall-bouncer.serviceConfig.EnvironmentFile = "${config.age.secrets.crowdsec-firewall-bouncer-key.path}";

  # containers.crowdsec = {
  #   autoStart = true;
  #   privateNetwork = true;
  #   hostAddress = "192.168.100.13";
  #   localAddress = "192.168.100.14";
  #   bindMounts = {
  #     "${config.age.secrets.nextcloud-admin-password.path}".isReadOnly = true;
  #   };
  #   config = let
  #     hostConfig = config;
  #   in
  #     {
  #       config,
  #       pkgs,
  #       crowdsec,
  #       ...
  #     }: {
  #       networking.useHostResolvConf = lib.mkForce false;
  #       networking.enableIPv6 = false;
  #       services.resolved.enable = true;
  #       system.stateVersion = "24.11";
  #
  #       imports = [inputs.crowdsec.nixosModules.crowdsec];
  #
  #       services.crowdsec = {
  #         enable = true;
  #         enrollKeyFile = "/run/agenix/crowdsec-enroll-key";
  #         settings = {
  #           api.server = {
  #             listen_uri = "127.0.0.1:8080";
  #           };
  #         };
  #       };
  #     };
  # };
}
