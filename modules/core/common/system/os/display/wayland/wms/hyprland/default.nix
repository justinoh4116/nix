{
  lib,
  inputs,
  config,
  pkgs,
  ...
}: let
  pkgs-hyprland = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};

  env = config.modules.usrEnv;
  sys = config.modules.system;
in {
  config = lib.mkIf (sys.video.enable && env.desktop.wm == "Hyprland") {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.system}.xdg-desktop-portal-hyprland;
    };

    hardware.graphics.package = pkgs-hyprland.mesa.drivers;
  };
}
