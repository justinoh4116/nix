{
  lib,
  osConfig,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.codex-desktop.homeManagerModules.default
  ];
  config = {
    programs.codexDesktopLinux = {
      enable = true;
      computerUseUi.enable = true;
      remoteMobileControl.enable = true;
      remoteControl.enable = true;
    };
    home.packages = with pkgs; [
      codex
    ];
  };
}
