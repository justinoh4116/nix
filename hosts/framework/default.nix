{
  inputs,
  self,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./steam.nix
    ./keyboard.nix
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
