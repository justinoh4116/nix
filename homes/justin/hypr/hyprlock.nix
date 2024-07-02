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

  services.hypridle = {
    enable = false;
    package = inputs.hypridle.packages.${pkgs.system}.hypridle;
  };

  home.file."${config.xdg.configHome}/hypr/hypridle.conf" = {
    source = ./hypridle.conf;
  };
}
