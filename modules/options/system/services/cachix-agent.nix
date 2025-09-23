{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) str;
in {
  options.modules.system.services.cachix-agent = {
    enable = mkEnableOption "cachix-agent on this device (makes deployable w/ cachix deploy)";

    credentialsFile = mkOption {
      type = str;
      description = "Path to the cachix-agent credentials file to be used";
    };
  };
}
