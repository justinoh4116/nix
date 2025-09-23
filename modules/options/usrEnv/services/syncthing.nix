{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) attrs str;
in {
  options.modules.usrEnv.services.syncthing = {
    enable = mkEnableOption "user syncthing service";

    key = mkOption {
      type = str;
      description = "Path to the syncthing key file to be used";
    };
    cert = mkOption {
      type = str;
      description = "Path to the syncthing cert file to be used";
    };

    folders = mkOption {
      type = attrs;
      description = "Passed directly to services.syncthing.settings.folders";
    };
    devices = mkOption {
      type = attrs;
      description = "Passed directly to services.syncthing.settings.devices";
    };
  };
}
