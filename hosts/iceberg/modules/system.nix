{
  pkgs,
  config,
  ...
}: {
  config.modules.system = {
    mainUser = "justin";

    fs.zfs = {
      enable = true;
      autoScrub = true;
      poolsToImport = ["zpool"];
      snapshots = true;
    };

    boot = {
      loader = "grub";
      secureBoot = false;
    };

    networking = {
      tailscale = {
        enable = true;
      };
    };

    programs = {
      cli.enable = true;

      fish.enable = true;
    };

    services = {
      cachix-agent = {
        enable = true;
        credentialsFile = config.age.secrets.iceberg-cachix-agent-token.path;
      };
      actual.enable = true;
      authelia.enable = true;
      caddy.enable = true;
      changedetection-io.enable = true;
      crowdsec.enable = true;
      ddclient.enable = true;
      immich.enable = true;
      nextcloud.enable = true;
      paperless.enable = true;
      samba.enable = true;
      vaultwarden.enable = true;
      wg-easy.enable = true;

      syncthing = {
        enable = true;
        key = config.age.secrets.iceberg-syncthing-key.path;
        cert = config.age.secrets.iceberg-syncthing-cert.path;

        folders = {
          "/persist/syncthing/obsidian" = {
            devices = ["framework" "iphone" "ipad"];
            id = "obsidian";
          };
        };
        devices = {
          framework.id = "SHVSOSG-EJD2AA4-IKP2JK6-UXDSRHD-YB6HWPE-TRQJTGT-AE5ZIUZ-PGM34Q6";
          iphone.id = "2JI3KAG-R6TIXZN-HNXCIXQ-ZROSDST-YVRAJWM-EZOPS54-N6373LB-DHHR5QT";
          ipad.id = "NS4EZLM-3THPRCD-VJI4INB-QYGPNZO-YRZJAHJ-NHR3BCA-22XHY3Z-SP6WYQ4";
        };
      };
    };
  };
}
