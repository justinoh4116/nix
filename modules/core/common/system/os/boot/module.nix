{
  config,
  lib,
  ...
}: {
  imports = [
    ./loaders

    ./secure-boot.nix
    ./generic.nix
    ./plymouth.nix
  ];
}
