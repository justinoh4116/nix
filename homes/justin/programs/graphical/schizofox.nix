{
  inputs,
  config,
  self,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.schizofox.homeManagerModule
  ];

  home.packages = [
    pkgs.firefox
  ];
  # programs.schizofox = {
  #   enable = true;

  #   theme = {
  #     colors = {
  #       background-darker = "1f2335";
  #       background = "24283b";
  #       foreground = "959cbd";
  #     };
  #   };

  #   search = {
  #     defaultSearchEngine = "Google";
  #     removeEngines = ["Bing" "Amazon.com" "eBay" "Twitter" "Wikipedia"];
  #   };

  #   misc = {
  #     drmFix = true;
  #   };

  #   extensions = {
  #     simplefox.enable = true;
  #     darkreader.enable = false;
  #   };
  # };
}
