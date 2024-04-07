{
  self,
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  imports = [
  ];

  home.file."${config.xdg.configHome}/nvim" = {
    source = ./dots;
    recursive = true;
  };

  home.packages = with pkgs; [
    lua-language-server
    arduino-language-server
    nil
  ];
}
