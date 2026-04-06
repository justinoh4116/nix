{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}: {
  config = {
    programs.vscode = {
      enable = true;
      package = pkgs.vscode.fhs;
    };
  };
}
