{
  inputs,
  self,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./github-runner.nix
    ./users.nix
    ./configuration.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./system.nix
  ];
}
