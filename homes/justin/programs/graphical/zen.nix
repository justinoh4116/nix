{
  inputs,
  self,
  pkgs,
  config,
  ...
}: {
  home.packages = [
    inputs.zen-browser.packages."${pkgs.system}".default
  ];

  home.file.".zen/2diywa1i.Default Profile/userChrome.css" = {
    source = ./userChrome.css;
  };
}
