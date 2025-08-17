{
  inputs,
  self,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./users.nix
    ./configuration.nix
    ./hardware-configuration.nix
  ];
}
