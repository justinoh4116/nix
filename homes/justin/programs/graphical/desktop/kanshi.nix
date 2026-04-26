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

      settings = [
        {
          profile.name = "undocked";
          profile.outputs = [
            {
              criteria = "eDP-1";
              scale = 1.33;
            }
          ];
          profile.exec = [
            "noctalia-shell ipc call bar setDisplayMode always_visible"
          ];
        }
        {
          profile.name = "docked";
          profile.outputs = [
            {
              criteria = "eDP-1";
              scale = 1.5;
            }
            {
              criteria = "LG Electronics LG ULTRAGEAR+ 511RMNECW663";
              position = "-2560,0";
              mode = "2560x1440@143.991";
            }
          ];
          profile.exec = [
            "noctalia-shell ipc call bar setDisplayMode auto_hide"
          ];
        }
      ];
    };
  };
}
