{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption mkEnableOption;
  cfg = config.modules.system.security;
in {
  options.modules.system.security = {
    fprint.enable = mkEnableOption "fingerprint login";
  };
}
