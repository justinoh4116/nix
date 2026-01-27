{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.modules.system.programs.gui.enable {
    programs.zathura = {
      enable = true;
      options = {
        recolor-lightcolor = "rgba(0,0,0,0.7)";
        default-bg = "rgba(0,0,0,0.7)";

        font = "SFPro Text Nerd Font 12";
        selection-notification = true;

        selection-clipboard = "clipboard";
        adjust-open = "best-fit";
        pages-per-row = "1";
        scroll-page-aware = "true";
        scroll-full-overlap = "0.01";
        scroll-step = "100";
        zoom-min = "10";
      };

      extraConfig = "include catppuccin-mocha";
    };

    xdg.configFile = {
      # "zathura/catppuccin-latte".source = pkgs.fetchurl {
      #   url = "https://raw.githubusercontent.com/catppuccin/zathura/9f29c2c1622c70436f0e0b98fea9735863596c1e/themes/catppuccin-latte";
      #   hash = "sha256-h1USn+8HvCJuVlpeVQyzSniv56R/QgWyhhRjNm9bCfY";
      # };
      "zathura/catppuccin-mocha".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/zathura/9f29c2c1622c70436f0e0b98fea9735863596c1e/themes/catppuccin-mocha";
        hash = "sha256-aUUT1ExI5kEeEawwqnW+n0XWe2b5j4tFdJbCh4XCFIs=";
      };
    };
  };
}
