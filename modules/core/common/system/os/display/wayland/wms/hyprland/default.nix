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
  cfg = env.desktop.wms.hyprland;

  inherit (pkgs.stdenv.hostPlatform) system;
in {
  imports = [
    inputs.hyprland.nixosModules.default

    ./binds.nix
    ./rules.nix
    ./settings.nix
    ./smartgaps.nix
  ];

  config = lib.mkIf (sys.video.enable && cfg.enable) {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
      # set the flake package
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      # make sure to also set the portal package, so that they are in sync
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    environment.variables.NIXOS_OZONE_WL = "1";

    environment.systemPackages = [
      inputs.hyprland-contrib.packages.${system}.grimblast
    ];

    environment.pathsToLink = ["/share/icons"];

    hardware.graphics = {
      package = pkgs-hyprland.mesa;

      # if you also want 32-bit support (e.g for Steam)
      enable32Bit = true;
      package32 = pkgs-hyprland.pkgsi686Linux.mesa;
    };
  };
}
