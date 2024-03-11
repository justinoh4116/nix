{
  inputs,
  self,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./power.nix
    ./audio.nix
    ./system.nix
    ./configuration.nix
    ./hardware-configuration.nix
    ./fonts.nix
    ./misc.nix
    ./cli.nix
  ];
}
