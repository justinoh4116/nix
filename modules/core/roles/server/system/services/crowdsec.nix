{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.modules.system.services.crowdsec;
in {
  imports = [
    inputs.crowdsec.nixosModules.crowdsec
    inputs.crowdsec.nixosModules.crowdsec-firewall-bouncer
  ];

  disabledModules = ["services/security/crowdsec.nix"];

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [inputs.crowdsec.overlays.default];

    networking.firewall.allowedTCPPorts = [8081];

    services = {
      crowdsec = let
        yaml = (pkgs.formats.yaml {}).generate;
        acquisitions_file = yaml "acquisitions.yaml" {
          source = "journalctl";
          journalctl_filter = ["_SYSTEMD_UNIT=sshd.service"];
          labels.type = "syslog";
        };
      in {
        enable = lib.mkForce true;
        allowLocalJournalAccess = true;
        settings = {
          crowdsec_service.acquisition_path = acquisitions_file;
          api.server = {
            listen_uri = "localhost:8081";
          };
        };
      };

      # package = inputs.crowdsec.packages.${pkgs.system}.crowdsec;
      #   enable = true;
      #   enrollKeyFile = config.age.secrets.crowdsec-enroll-key.path;
      #   settings = {
      #     api.server = {
      #       listen_uri = "127.0.0.1:8081";
      #     };
      #   };
      # ;

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
            cscli bouncers add "iceberg-firewall" --key ''$(cat "${config.age.secrets.crowdsec-firewall-bouncer-key.path}" | ${pkgs.gnused}/bin/sed "s/FIREWALL_KEY=//")
          fi
          if ! cscli bouncers list | grep -q "caddy"; then
            cscli bouncers add "caddy" --key ''$(cat ${config.age.secrets.crowdsec-caddy-bouncer-key.path})
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
  };
}
