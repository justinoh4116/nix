{
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.modules.system.programs.gui.enable {
    programs.foot = {
      enable = true;

      settings = {
        main = {
          font = "IosevkaTerm Nerd Font:size=14:fontfeatures=-calt:fontfeatures=VRLG";
          font-size-adjustment = 1;
          pad = "12x9";
        };

        scrollback = {
          lines = 10000;
        };

        cursor = {
          style = "beam";
          blink = "no";
        };

        "colors-dark" = {
          foreground = "e5e5ea";
          background = "1e1e1e";
          cursor = "1e1e1e f5f5f7";
          selection-foreground = "f5f5f7";
          selection-background = "0a84ff";

          regular0 = "3a3a3c";
          regular1 = "ff453a";
          regular2 = "30d158";
          regular3 = "ffd60a";
          regular4 = "0a84ff";
          regular5 = "bf5af2";
          regular6 = "64d2ff";
          regular7 = "e5e5ea";

          bright0 = "636366";
          bright1 = "ff6961";
          bright2 = "32d74b";
          bright3 = "ffe066";
          bright4 = "409cff";
          bright5 = "da8fff";
          bright6 = "70d7ff";
          bright7 = "ffffff";

          alpha = 1.0;
        };

        "key-bindings" = {
          font-increase = "Control+plus Control+equal";
          font-decrease = "Control+minus";
        };

        "text-bindings" = {
          "\\x17" = "Control+BackSpace";
          "\\x00f" = "Alt+f";
          "\\x00p" = "Alt+p";
          "\\x00c" = "Alt+c";
          "\\x00t" = "Alt+t";
          "\\x00[" = "Control+Shift+g";
        };
      };
    };
  };
}
