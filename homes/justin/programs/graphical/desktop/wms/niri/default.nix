{
  osConfig,
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  env = osConfig.modules.usrEnv;
  cfg = env.desktop.wms.niri;
  desktop = osConfig.modules.usrEnv.desktop;
in {
  imports = [
  ];
  config = lib.mkIf (desktop.enable && cfg.enable) {
    home.packages = [
      pkgs.libnotify
    ];
    home.file."${config.xdg.configHome}/niri" = {
      source = ./dots;
      recursive = true;
    };
    programs.niri = {
      # enable = true;
      # package = inputs.niri-flake.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;
      config = null;
    };
  };
}
