{
  lib,
  osConfig,
  ...
}: let
  cfg = osConfig.modules.usrEnv.desktop.kanshi;
in {
  config = lib.mkIf cfg.enable {
    services.kanshi = {
      enable = true;

      profiles = {
        undocked = {
          outputs = [
            {
              criteria = "eDP-1";
              scale = 1.33;
            }
          ];
          exec = [
            "noctalia-shell ipc call bar setDisplayMode always_visible"
          ];
        };
        docked = {
          outputs = [
            {
              criteria = "eDP-1";
              scale = 1.5;
            }
            {
              criteria = "LG Electronics LG ULTRAGEAR+ 511RMNECW663";
              position = "-2560,0";
            }
          ];
          exec = [
            "noctalia-shell ipc call bar setDisplayMode auto_hide"
          ];
        };
      };
    };
  };
}
