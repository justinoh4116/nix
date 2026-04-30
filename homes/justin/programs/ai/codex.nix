{
  lib,
  osConfig,
  pkgs,
  ...
}: {
  config = {
    home.packages = with pkgs; [
      codex
    ];
  };
}
