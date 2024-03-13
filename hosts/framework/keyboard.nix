{
  inputs,
  self,
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    inputs.kmonad.nixosModules.default
  ];

  services.kmonad = {
    enable = true;

    keyboards.internal = {
      device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
      config = builtins.readFile ./dots/framework.kbd;

      defcfg = {
        enable = true;
        fallthrough = true;
      };
    };
  };
}
