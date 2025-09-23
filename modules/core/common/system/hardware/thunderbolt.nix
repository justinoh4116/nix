{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.modules.system.services.bolt.enable {
    services.hardware.bolt.enable = true;
  };
}
