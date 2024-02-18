{ self, config, lib, pkgs, inputs, ... }: {
  imports = [

  ];

  home.packages = [

  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    # reloadConfig= true;

    xwayland.enable = true;
  };
}
