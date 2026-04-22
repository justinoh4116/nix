{
  inputs,
  self,
  pkgs,
  config,
  lib,
  osConfig,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  # config = lib.mkIf (osConfig.modules.system.programs.default.browser == "zen") {
  config = {
    programs.zen-browser = {
      enable = true;
    };
  };
}
