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
          devices = ["framework" "iphone" "ipad" "framework_windows"];
          id = "obsidian";
        };
      };
      devices = {
        framework.id = "SHVSOSG-EJD2AA4-IKP2JK6-UXDSRHD-YB6HWPE-TRQJTGT-AE5ZIUZ-PGM34Q6";
        framework_windows.id = "WI7VNIE-2HUM3SV-U5WR4UO-N66GJQI-GZ7ACCD-UMCKMK2-NNQMG3P-JJTUAAP";
        iphone.id = "2JI3KAG-R6TIXZN-HNXCIXQ-ZROSDST-YVRAJWM-EZOPS54-N6373LB-DHHR5QT";
        ipad.id = "NS4EZLM-3THPRCD-VJI4INB-QYGPNZO-YRZJAHJ-NHR3BCA-22XHY3Z-SP6WYQ4";
      };
    };
  };
}
