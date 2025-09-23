{
  pkgs,
  lib,
  ...
}: {
  services.xserver.xkb = {
    options = "compose:ralt";
    layout = "us";
  };

  i18n.defaultLocale = "en_US.UTF-8";
}
