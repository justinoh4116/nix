{
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.modules.system.programs.gui.enable {
    programs.ghostty = {
      enable = true;
      enableFishIntegration = true;

      settings = {
        auto-update = "off";
        confirm-close-surface = false;

        font-family = "IosevkaTerm Nerd Font";
        # font-style = "Medium";
        font-size = 14;
        font-feature = [
          "-calt"
          "VRLG"
        ];

        background-opacity = 1;
        scrollback-limit = 10000;

        cursor-style = "bar";
        cursor-style-blink = false;

        window-padding-x = 12;
        window-padding-y = 9;
        window-padding-color = "background";
        window-show-tab-bar = "auto";
        gtk-tabs-location = "top";
        window-theme = "ghostty";

        theme = "Vague";

        keybind = [
          "ctrl+shift++=increase_font_size:1"
          "ctrl+shift+-=decrease_font_size:1"

          "ctrl+backspace=text:\\x17"

          "alt+f=text:\\x00"
          "chain=text:f"

          "alt+n=text:\\x00"
          "chain=text:n"

          "alt+p=text:\\x00"
          "chain=text:p"

          "alt+c=text:\\x00"
          "chain=text:c"

          "alt+t=text:\\x00"
          "chain=text:t"

          "ctrl+shift+g=text:\\x00"
          "chain=text:["
        ];
      };

      themes.Vague = {
        background = "#141415";
        foreground = "#cdcdcd";
        cursor-color = "#cdcdcd";
        cursor-text = "#141415";
        selection-background = "#333738";
        selection-foreground = "#cdcdcd";

        palette = [
          "0=#252530"
          "1=#d8647e"
          "2=#7fa563"
          "3=#f3be7c"
          "4=#6e94b2"
          "5=#bb9dbd"
          "6=#b4d4cf"
          "7=#cdcdcd"
          "8=#606079"
          "9=#d8647e"
          "10=#7fa563"
          "11=#f3be7c"
          "12=#7e98e8"
          "13=#aeaed1"
          "14=#9bb4bc"
          "15=#ffffff"
        ];
      };
    };
  };
}
