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
    ./gestures.nix
  ];

  home.packages = [
    inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;

    xwayland.enable = true;
  };

  # home.file."${config.xdg.configHome}/hypr/scripts/screenshot" = {
  #   executable = true;
  #   source = "./scripts/screenshot";
  # };
}
