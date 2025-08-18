{
  config,
  inputs,
  lib,
  ...
}: {
  imports = [
    ../../modules/programs/fish.nix
  ];

  modules.programs.fish.enable = true;
}
