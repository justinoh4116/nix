{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) str enum bool package int;

  cfg = config.modules.usrEnv.desktop;
in {
  options.modules.usrEnv.desktop = {
    wm = mkOption {
      type = enum ["Hyprland" "river" "none"];
      default = "Hyprland";
    };
    wms = {
      hyprland.enable = mkOption {
        type = bool;
        default = cfg.wm == "Hyprland";
      };

      river.enable = mkOption {
        type = bool;
        default = cfg.wm == "river";
      };
    };

    bars = {
      ags-old = {
        enable = mkEnableOption "ags-old bar";
      };
      ags = {
        enable = mkEnableOption "ags bar";
      };
    };
    cursor = {
      package = mkOption {
        type = package;
        default = pkgs.apple-cursor;
        description = ''
          The cursor package to be used
        '';
      };
      name = mkOption {
        type = str;
        default = "macOS-White";
        description = ''
          The cursor name to be used
        '';
      };
      size = mkOption {
        type = int;
        default = 24;
        description = ''
          The cursor size to be used
        '';
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
