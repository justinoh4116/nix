{
  config,
  lib,
  ...
}: {
  config =
    lib.mkIf config.modules.system.printing.enable {
      services.printing.enable = true;
    };
}
