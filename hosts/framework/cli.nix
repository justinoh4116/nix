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

    nix-your-shell
  ];
}
