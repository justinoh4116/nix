{
  inputs,
  self,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./caddy.nix
    ./network.nix
    ./configuration.nix
    ./cli.nix
    ./hardware-configuration.nix
    ./tailscale.nix
    ./immich.nix
  ];
}
