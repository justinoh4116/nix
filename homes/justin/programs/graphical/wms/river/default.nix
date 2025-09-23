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
in {
  imports = [
    ./config.nix
  ];
  config = mkIf env.desktop.wms.river.enable {
    wayland.windowManager.river = {
      enable = true;
      xwayland.enable = true;
    };
  };
}
