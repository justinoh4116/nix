{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) str enum bool package int;

  cfg = config.modules.usrEnv.programs;
in {
  options.modules.usrEnv.programs = {
    latex.enable = mkEnableOption "latex";
  };
}
