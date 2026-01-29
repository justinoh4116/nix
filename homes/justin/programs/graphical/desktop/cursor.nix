{
  lib,
  osConfig,
  ...
}: let
  env = osConfig.modules.usrEnv;
  cfg = env.desktop.cursor;
in {
  home.pointerCursor = {
    gtk.enable = true;
    name = cfg.name;
    package = cfg.package;
    size = cfg.size;
    x11 = {
      defaultCursor = cfg.name;
      enable = true;
    };
  };
}
