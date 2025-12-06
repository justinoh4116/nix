{
  config,
  osConfig,
  lib,
  ...
}: {
  config = lib.mkIf osConfig.modules.system.video.enable {
    services.gammastep = {
      enable = true;
      tray = true;
      # provider = "geoclue2";
      latitude = 37.4419;
      longitude = -122.1430;
    };
  };
}
