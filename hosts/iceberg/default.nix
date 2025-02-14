{
  inputs,
  self,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./configuration.nix
    ./cli.nix
    ./hardware-configuration.nix
  ];
}
