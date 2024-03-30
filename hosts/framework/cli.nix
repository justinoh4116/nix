{
  self,
  inputs,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    python3
    gcc
    cmake
    rustup
    tldr

    nix-your-shell
  ];
}
