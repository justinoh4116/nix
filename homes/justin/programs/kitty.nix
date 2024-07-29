{
  inputs,
  lib,
  config,
  ...
}: {
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;

    font = {
      name = "FiraCode Nerd Font";
      size = 13;
    };

    theme = "Tokyo Night";

    settings = {
    };

    extraConfig = ''
      background_opacity 0.9
      window_padding_width 4
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
}
