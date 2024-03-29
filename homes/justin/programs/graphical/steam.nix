{
  inputs,
  self,
  pkgs,
  config,
  ...
}: let
in {
  nixpkgs.config.allowUnfreePredicate = _: true;
  programs.steam = {
    enable = true;
  };
}
