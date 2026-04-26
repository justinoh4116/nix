{
  inputs,
  self,
  pkgs,
  config,
  lib,
  osConfig,
  ...
}: {
  home.packages = [
    # inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".beta
  ];

  # config = lib.mkIf (osConfig.modules.system.programs.default.browser == "zen") {
  # config = {
  #   programs.zen-browser = {
  #     enable = true;
  #   };
  # };
}
