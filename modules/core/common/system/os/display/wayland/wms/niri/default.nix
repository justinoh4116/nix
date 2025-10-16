{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  pkgs-niri = inputs.niri-flake.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};

  sys = config.modules.system;
  env = config.modules.usrEnv;
  cfg = env.desktop.wms.niri;
in {
  imports = [
    inputs.niri-flake.nixosModules.niri
  ];

  config = lib.mkIf (env.desktop.wm == "niri" && sys.video.enable) {
    programs.niri.enable = true;

    environment.systemPackages = [
      pkgs.xwayland-satellite
    ];

    hardware.graphics.package = pkgs-niri.mesa.drivers;
  };
}
