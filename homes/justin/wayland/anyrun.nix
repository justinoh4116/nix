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
  };
}
