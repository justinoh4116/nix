{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  env = osConfig.modules.usrEnv;
  cfg = env.desktop.wms.niri;
in {
  config = lib.mkIf cfg.enable {
    programs.niri = {
      config = null;
    };
  };
}
