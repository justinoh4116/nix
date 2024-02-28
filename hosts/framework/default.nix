{
  inputs,
  self,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./system.nix
    ./configuration.nix
    ./hardware-configuration.nix
    ./fonts.nix
  ];
}
