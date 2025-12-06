{
  config,
  lib,
  ...
}: let
  inherit (lib) mkAgenixSecret;
  inherit (lib.strings) optionalString;

  sys = config.modules.system;
  cfg = sys.services;
in {
  age.identityPaths = [
    "${optionalString sys.impermanence.root.enable "/persist"}/etc/ssh/ssh_host_ed25519_key"
    "${optionalString sys.impermanence.home.enable "/persist"}/home/justin/.ssh/id_ed25519"
  ];

  age.secrets = {
    # firefox-syncserver-secrets = mkAgenixSecret cfg.firefox-syncserver.enable {
    #   file = "firefox-syncserver-secrets.age";
    # };

    nix-access-tokens-github = mkAgenixSecret true {
      file = "nix-access-tokens-github.age";
    };

    tailscale-auth = mkAgenixSecret true {
      file = "tailscale-auth.age";
    };

    framework-cachix-agent-token = mkAgenixSecret true {
      file = "framework-cachix-agent-token.age";
    };

    iceberg-cachix-agent-token = mkAgenixSecret true {
      file = "iceberg-cachix-agent-token.age";
    };

    zfs-pushover-token = mkAgenixSecret true {
      file = "zfs-pushover-token.age";
    };

    pushover-user-key = mkAgenixSecret true {
      file = "pushover-user-key.age";
    };

    crowdsec-enroll-key = mkAgenixSecret cfg.crowdsec.enable {
      file = "crowdsec-enroll-key.age";
      owner = "crowdsec";
      group = "crowdsec";
      mode = "770";
    };

    crowdsec-firewall-bouncer-key = mkAgenixSecret cfg.crowdsec.enable {
      file = "crowdsec-firewall-bouncer-key.age";
      owner = "crowdsec";
      group = "crowdsec";
      mode = "770";
    };

    crowdsec-caddy-bouncer-key = mkAgenixSecret cfg.crowdsec.enable {
      file = "crowdsec-caddy-bouncer-key.age";
      owner = "crowdsec";
      group = "crowdsec";
      mode = "770";
    };

    nextcloud-admin-password = mkAgenixSecret cfg.nextcloud.enable {
      file = "nextcloud-admin-password.age";
    };

    paperless-admin-password = mkAgenixSecret cfg.paperless.enable {
      file = "paperless-admin-password.age";
    };

    porkbun-api-key = mkAgenixSecret true {
      file = "porkbun-api-key.age";
    };

    porkbun-secret-key = mkAgenixSecret true {
      file = "porkbun-secret-key.age";
    };

    iceberg-syncthing-key = mkAgenixSecret cfg.syncthing.enable {
      file = "iceberg-syncthing-key.age";
      owner = "syncthing";
      group = "syncthing";
      mode = "770";
    };

    iceberg-syncthing-cert = mkAgenixSecret cfg.syncthing.enable {
      file = "iceberg-syncthing-cert.age";
      owner = "syncthing";
      group = "syncthing";
      mode = "770";
    };

    cachix-activate-token = mkAgenixSecret true {
      file = "cachix-activate-token.age";
      owner = "justin";
      group = "users";
    };

    copyparty-password = mkAgenixSecret cfg.copyparty.enable {
      file = "copyparty-password.age";
      owner = "copyparty";
      group = "copyparty";
    };

    framework-syncthing-key = true {
      file = "syncthing-key.age";
    };

    framework-syncthing-cert = true {
      file = "syncthing-cert.age";
    };
  };
}
