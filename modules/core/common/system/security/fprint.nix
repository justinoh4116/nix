{
  config,
  lib,
  ...
}: let
  sys = config.modules.system;
in {
  config = lib.mkIf sys.security.fprint.enable {
    services.fprintd = {
      enable = true;
      # tod.enable = true;
      # tod.driver = pkgs.libfprint-2-tod1-goodix;
    };

    security.pam.services = {
      login.fprintAuth = true;
      swaylock.fprintAuth = true;
    };
  };
}
