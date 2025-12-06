{
  pkgs,
  config,
  ...
}: {
  config.modules.usrEnv = {
    desktop = {
      wms = {
        hyprland.enable = true;
        river.enable = true;
        niri.enable = true;
      };
      wm = "niri";
    };
    services = {
      syncthing = {
        enable = true;
        key = config.age.secrets.framework-syncthing-key.path;
        cert = config.age.secrets.framework-syncthing-cert.path;

        folders = {
          "/home/justin/safe/obsidian" = {
            id = "obsidian";
            devices = ["iceberg" "iphone" "ipad"];
          };
          devices = {
            iceberg.id = "OLRTR4Y-SRJ6G3V-W2EAXQK-COHX3LW-FZUVWAG-PEF4JIL-G7IM2KZ-64CJSAJ";
            iphone.id = "2JI3KAG-R6TIXZN-HNXCIXQ-ZROSDST-YVRAJWM-EZOPS54-N6373LB-DHHR5QT";
            ipad.id = "NS4EZLM-3THPRCD-VJI4INB-QYGPNZO-YRZJAHJ-NHR3BCA-22XHY3Z-SP6WYQ4";
          };
        };
      };
    };
  };
}
