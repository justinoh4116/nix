{
  osConfig,
  pkgs,
  lib,
  config,
  ...
}: let
  env = osConfig.modules.usrEnv;
  cfg = env.desktop.wms.niri;
in {
  config = lib.mkIf cfg.enable {
    home.file."${config.xdg.configHome}/niri" = {
      source = ./dots;
      recursive = true;
    };
    programs.niri = {
      config = null;
    };
  };
}
