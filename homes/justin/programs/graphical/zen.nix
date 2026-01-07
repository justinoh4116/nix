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
    inputs.zen-nebula.homeModules.default
  ];

  config = lib.mkIf (osConfig.modules.system.programs.default.browser == "zen") {
    zen-nebula = {
      enable = true;
      profile = "2diywa1i.Default Profile";
    };

    home.packages = [
      inputs.zen-browser.packages."${pkgs.system}".default
    ];

    # home.file.".zen/2diywa1i.Default Profile/userChrome.css" = {
    #   source = ./userChrome.css;
    # };
  };
}
