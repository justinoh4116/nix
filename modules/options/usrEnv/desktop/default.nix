{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) str enum bool package;

  cfg = config.modules.usrEnv.desktop;
in {
  options.modules.usrEnv.desktop = {
    wm = mkOption {
      type = enum ["Hyprland" "river"];
      default = "none";
    };
    wms = {
      hyprland = mkOption {
        type = bool;
        default = cfg.wm == "Hyprland";
      };

      river = mkOption {
        type = bool;
        default = cfg.wm == "river";
      };
    };

    launchers = {
      anyrun.enable = mkEnableOption "anyrun launcher";
    };

    screenlock = {
      gtk.enable = mkEnableOption "gtklock";
      swaylock.enable = mkEnableOption "swaylock";
      hyprlock.enable = mkEnableOption "hyprlock";

      package = mkOption {
        type = package;
        description = "the locker package";
      };
    };
  };
}
