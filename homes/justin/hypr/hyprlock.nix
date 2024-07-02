{
  self,
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    # inputs.hyprpaper.homeManagerModules.default
  ];

  programs.hyprlock = {
    enable = true;

    settings = {
    };
  };

  home.file."${config.xdg.configHome}/hypr/hypridle.conf" = {
    source = ./hypridle.conf;
  };

  home.packages = [
    inputs.hypridle.packages.${pkgs.system}.hypridle
  ];
}
