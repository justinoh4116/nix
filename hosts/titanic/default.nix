{
  inputs,
  self,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./programs.nix
    ./github-runner.nix
    ./users.nix
    ./configuration.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./system.nix
  ];
}
