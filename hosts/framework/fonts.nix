{
  self,
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    fira-code
    fira-code-symbols

    (nerdfonts.override {fonts = ["FiraCode"];})
  ];
}
