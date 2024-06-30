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
}
