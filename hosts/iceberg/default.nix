{
  inputs,
  self,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
  ];
}
