{
  inputs,
  self,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./github-runner.nix
    ./vaultwarden.nix
    ./caddy.nix
    ./network.nix
    ./configuration.nix
    ./cli.nix
    ./hardware-configuration.nix
    ./tailscale.nix
    ./immich.nix
  ];
}
