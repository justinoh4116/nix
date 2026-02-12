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

  # home.activation.nvimDapBin = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #   configFile=${config.xdg.configHome}/nvim/lua/justin/plugins/debugger.lua
  #   ${pkgs.gnused}/bin/sed -i "s#@@opendebug-ad7-executable@@#${pkgs.vscode-extensions.ms-vscode.cpptools}/debugAdapters/bin/OpenDebugAD7#" "$configFile"
  #   ${pkgs.gnused}/bin/sed -i "s#@@cpp-debugger-executable@@#${pkgs.lldb}/bin/lldb#" "$configFile"
  # '';

  home.packages = with pkgs; [
    verible
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
