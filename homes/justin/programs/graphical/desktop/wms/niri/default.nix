{
  osConfig,
  pkgs,
  lib,
  config,
  ...
}: let
  env = osConfig.modules.usrEnv;
  cfg = env.desktop.wms.niri;
  desktop = osConfig.modules.usrEnv.desktop;
in {
  config = lib.mkIf (desktop.enable && cfg.enable) {
    home.file."${config.xdg.configHome}/niri" = {
      source = ./dots;
      recursive = true;
    };
    programs.niri = {
      config = null;
    };
  };
}
