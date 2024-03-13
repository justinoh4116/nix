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
  };
}
