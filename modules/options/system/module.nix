{
  config,
  lib,
  ...
}: let
  inherit (builtins) elemAt;
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) package listOf str enum;

  sys = config.modules.system;
in {
  imports = [
    ./services
    ./programs
    ./networking

    ./boot.nix
    ./fs.nix
    ./security.nix
    ./impermanence.nix
  ];
  options.modules.system = {
    mainUser = mkOption {
      type = enum sys.users;
      default = elemAt sys.users 0;
      description = "default user for the system";
    };

    users = mkOption {
      type = listOf str;
      default = ["justin"];
      description = "list of home-maager users";
    };

    sound.enable = mkEnableOption "sound-related programs";
    bluetooth.enable = mkEnableOption "bluetooth";
    video.enable = mkEnableOption "graphics related programs / drivers";

    printing = {
      enable = mkEnableOption "printing";
      extraDrivers = mkOption {
        type = listOf package;
        description = "list of additional printer driver packages";
      };
    };
  };
}
