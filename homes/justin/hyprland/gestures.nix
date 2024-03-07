{
  inputs,
  pkgs,
  self,
  config,
  lib,
  ...
}: {
  home.packages = [
    inputs.gestures.packages.${pkgs.system}.gestures
    pkgs.ydotool
  ];

  home.file."${config.xdg.configHome}/gestures/gestures.kdl" = {
    source = ./gestures.kdl;
  };
}
