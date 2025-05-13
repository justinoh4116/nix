{
  self,
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./config.nix
    ./rules.nix
    # ./gestures.nix
    ./hyprlock.nix
  ];

  home.packages = [
    inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    inputs.pyprland.packages.${pkgs.system}.pyprland
    pkgs.libnotify
    pkgs.apple-cursor
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;

    xwayland.enable = true;
  };

  home.file."${config.xdg.configHome}/hypr/scripts/" = {
    recursive = true;
    source = ./scripts;
  };
}
