{
  inputs,
  self,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./audio.nix
    ./system.nix
    ./configuration.nix
    ./hardware-configuration.nix
    ./fonts.nix
    ./misc.nix
    ./cli.nix
  ];
}
