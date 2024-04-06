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
      size = 14;
    };

    theme = "Tokyo Night";

    settings = {
    };

    # extraConfig = ''

    #   font_family "FiraCode Nerd Font";
    #   bold_font "FiraCode Bold Nerd Font Complete";
    #   #italic_font "Firatalic Italic";
    #   #bold_italic_font "Firatalic BoldItalic";

    #   #font_features "FiraCodeNerdFontComplete-Regular +cv05 +cv09 +cv14 +ss04 +cv16 +cv31 +cv25 +cv26 +cv32 +cv28 +onum";
    #   #font_features "FiraCodeNerdFontComplete-Bold +cv05 +cv09 +cv14 +ss04 +cv16 +cv31 +cv25 +cv26 +cv32 +cv28 +onum";
    #   #font_features "Firatalic-Italic +cv05 +cv09 +cv14 +ss04 +cv16 +cv31 +cv25 +cv26 +cv32 +cv28 +onum";
    #   #font_features "Firatalic-BoldItalic +cv05 +cv09 +cv14 +ss04 +cv16 +cv31 +cv25 +cv26 +cv32 +cv28 +onum";
    # '';
  };
}
