{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.types) str enum listOf;
  inherit (lib) mkOption;
in {
  options.modules.meta = {
    hostName = mkOption {
      type = str;
      default = config.networking.hostName;
      readOnly = true;
      description = "hostname";
    };
  };
}
