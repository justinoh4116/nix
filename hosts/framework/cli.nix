{
  self,
  inputs,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages."${system}".default
    python3
    gcc
    cmake
    rustup
    tldr

    nix-your-shell
  ];
}
