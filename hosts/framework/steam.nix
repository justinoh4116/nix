{
  inputs,
  self,
  pkgs,
  config,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfreePredicate = _: true;
  programs.steam = {
    enable = true;
  };
}
