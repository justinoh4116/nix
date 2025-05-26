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

  services.syncthing = {
    enable = true;
    key = config.age.secrets.iceberg-syncthing-key.path;
    cert = config.age.secrets.iceberg-syncthing-cert.path;
    openDefaultPorts = true;
    settings = {
      folders = {
        "/persist/syncthing/obsidian" = {
          devices = ["framework"];
          id = "obsidian";
        };
      };
      devices = {
        framework.id = "SHVSOSG-EJD2AA4-IKP2JK6-UXDSRHD-YB6HWPE-TRQJTGT-AE5ZIUZ-PGM34Q6";
      };
    };
  };
}
