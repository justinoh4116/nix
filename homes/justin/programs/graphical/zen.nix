{
  inputs,
  self,
  pkgs,
  config,
  ...
}: {
  imports = [
    inputs.zen-nebula.homeModules.default
  ];

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
}
