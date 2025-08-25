{lib, ...}: let
  inherit (lib) mkOption;
  inherit (lib.types) str;
in {
  imports = [
    ./colors.nix
  ];
}
