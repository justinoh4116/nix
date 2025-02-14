{
  inputs,
  self,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./network.nix
    ./configuration.nix
    ./cli.nix
    ./hardware-configuration.nix
    ./tailscale.nix
  ];
}
