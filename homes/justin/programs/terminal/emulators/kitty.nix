{
  inputs,
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.modules.system.programs.gui.enable {
    programs.kitty = {
      enable = true;
      shellIntegration.enableFishIntegration = true;

      font = {
        name = "Iosevka Nerd Font";
        size = 13;
      };

      themeFile = "tokyo_night_night";

      settings = {
      };

      extraConfig = ''
        background_opacity 0.8
        window_padding_width 4

        map ctrl+shift+n no_op
        map ctrl+shift+p no_op
      '';
      #   font_family "FiraCode Nerd Font";
      #   bold_font "FiraCode Bold Nerd Font Complete";
      #   #italic_font "Firatalic Italic";
      #   #bold_italic_font "Firatalic BoldItalic";

      #   #font_features "FiraCodeNerdFontComplete-Regular +cv05 +cv09 +cv14 +ss04 +cv16 +cv31 +cv25 +cv26 +cv32 +cv28 +onum";
      #   #font_features "FiraCodeNerdFontComplete-Bold +cv05 +cv09 +cv14 +ss04 +cv16 +cv31 +cv25 +cv26 +cv32 +cv28 +onum";
      #   #font_features "Firatalic-Italic +cv05 +cv09 +cv14 +ss04 +cv16 +cv31 +cv25 +cv26 +cv32 +cv28 +onum";
      #   #font_features "Firatalic-BoldItalic +cv05 +cv09 +cv14 +ss04 +cv16 +cv31 +cv25 +cv26 +cv32 +cv28 +onum";
    };
  };
}
