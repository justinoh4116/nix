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
          foreground = "cdcdcd";
          background = "141415";
          cursor = "141415 cdcdcd";
          selection-foreground = "cdcdcd";
          selection-background = "333738";

          regular0 = "252530";
          regular1 = "d8647e";
          regular2 = "7fa563";
          regular3 = "f3be7c";
          regular4 = "6e94b2";
          regular5 = "bb9dbd";
          regular6 = "b4d4cf";
          regular7 = "cdcdcd";

          bright0 = "606079";
          bright1 = "d8647e";
          bright2 = "7fa563";
          bright3 = "f3be7c";
          bright4 = "7e98e8";
          bright5 = "aeaed1";
          bright6 = "9bb4bc";
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
