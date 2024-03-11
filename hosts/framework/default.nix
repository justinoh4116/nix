{
  inputs,
  self,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./suspend-then-hibernate.nix
    ./audio.nix
    ./system.nix
    ./configuration.nix
    ./hardware-configuration.nix
    ./fonts.nix
    ./misc.nix
    ./cli.nix
  ];
}
