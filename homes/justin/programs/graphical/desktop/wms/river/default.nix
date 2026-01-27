{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: let
  inherit (osConfig) modules;
  inherit (lib) mkIf;
  env = modules.usrEnv;
  desktop = osConfig.modules.usrEnv.desktop;
in {
  imports = [
    ./config.nix
  ];
  config = mkIf (desktop.enable && env.desktop.wms.river.enable) {
    wayland.windowManager.river = {
      enable = true;
      xwayland.enable = true;
    };
  };
}
