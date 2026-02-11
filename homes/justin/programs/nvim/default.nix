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

  home.activation.nvimDapBin = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${pkgs.gnused}/bin/sed -i "s#@porkbun-api-key@#$apiKey#" "$configFile"
    ${pkgs.gnused}/bin/sed -i "s#@porkbun-secret-key@#$secretKey#" "$configFile"
  '';

  home.packages = with pkgs; [
    libclang
    texlab
    lua-language-server
    arduino-language-server
    nil
    pyright
    typescript
    typescript-language-server

    tree-sitter

    isort
    black
    ruff
    prettierd
    alejandra
    stylua
  ];
}
