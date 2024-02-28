{ self, config, lib, pkgs, inputs, ... }: {
  imports = [
    ./config.nix
  ];

  home.packages = [

  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;

    xwayland.enable = true;
  };
}
