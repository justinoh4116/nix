{
  config,
  pkgs,
  inputs,
  ...
}: {
  age.secrets.framework-syncthing-key.file = ../../../secrets/syncthing-key.age;
  age.secrets.framework-syncthing-cert.file = ../../../secrets/syncthing-cert.age;

  services.syncthing = {
    enable = true;
    # user = "justin";
    # group = "justin";
    # dataDir = "/home/justin/syncthing_test";
    # configDir = "/home/justin/.config/syncthing";
    key = config.age.secrets.framework-syncthing-key.path;
    cert = config.age.secrets.framework-syncthing-cert.path;

    # tray.enable = true;

    settings = {
      folders = {
        "/home/justin/safe/obsidian" = {
          id = "obsidian";
          devices = ["iceberg" "iphone"];
        };
      };
      devices = {
        iceberg.id = "OLRTR4Y-SRJ6G3V-W2EAXQK-COHX3LW-FZUVWAG-PEF4JIL-G7IM2KZ-64CJSAJ";
        iphone.id = "2JI3KAG-R6TIXZN-HNXCIXQ-ZROSDST-YVRAJWM-EZOPS54-N6373LB-DHHR5QT";
      };
    };
  };
}
