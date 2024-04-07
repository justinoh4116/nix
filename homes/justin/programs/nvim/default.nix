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
    luajitPackages.lua-lsp
    arduino-language-server
  ];
}
