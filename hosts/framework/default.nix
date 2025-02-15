{
  inputs,
  self,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./services
    ./virtmanager.nix
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
    ./secureboot.nix
    ./cachix.nix
  ];
}
