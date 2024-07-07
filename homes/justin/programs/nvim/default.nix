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
    libclang
    texlab
    lua-language-server
    arduino-language-server
    nil
    pyright

    isort
    black
    prettierd
    alejandra
    stylua
  ];
}
