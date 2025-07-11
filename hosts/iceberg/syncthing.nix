{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  age.secrets.iceberg-syncthing-key = {
    file = ../../secrets/iceberg-syncthing-key.age;
    owner = "syncthing";
    group = "syncthing";
    mode = "770";
  };

  age.secrets.iceberg-syncthing-cert = {
    file = ../../secrets/iceberg-syncthing-cert.age;
    owner = "syncthing";
    group = "syncthing";
    mode = "770";
  };

  networking.firewall.allowedTCPPorts = [22000];
  networking.firewall.allowedUDPPorts = [
    22000
    21027
  ];

  services.syncthing = {
    enable = true;
    key = config.age.secrets.iceberg-syncthing-key.path;
    cert = config.age.secrets.iceberg-syncthing-cert.path;
    openDefaultPorts = true;
    settings = {
      folders = {
        "/persist/syncthing/obsidian" = {
          devices = ["framework" "iphone"];
          id = "obsidian";
        };
      };
      devices = {
        framework.id = "SHVSOSG-EJD2AA4-IKP2JK6-UXDSRHD-YB6HWPE-TRQJTGT-AE5ZIUZ-PGM34Q6";
        iphone.id = "2JI3KAG-R6TIXZN-HNXCIXQ-ZROSDST-YVRAJWM-EZOPS54-N6373LB-DHHR5QT";
      };
    };
  };
}
