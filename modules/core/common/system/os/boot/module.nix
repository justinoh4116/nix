{
  config,
  lib,
  ...
}: {
  imports = lib.mkIf (!lib.isWSL config) [
    ./loaders

    ./secure-boot.nix
    ./generic.nix
    ./plymouth.nix
  ];
}
