{
  self,
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [inputs.anyrun.homeManagerModules.default];

  programs.anyrun = {
    enable = true;
    config = {
      plugins = [
        inputs.anyrun.packages.${pkgs.system}.applications
        inputs.anyrun.packages.${pkgs.system}.rink
        inputs.anyrun.packages.${pkgs.system}.randr
      ];
      width = { fraction = 0.3; };
      height = { fraction = 0.2; };
      x = { fraction = 0.5; };
      y = { fraction = 0.3; };
      layer = "overlay";
    };
  };
}
