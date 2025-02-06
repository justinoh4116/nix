{
  self,
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  fonts.packages = [
    pkgs.dejavu_fonts
    pkgs.noto-fonts
    pkgs.noto-fonts-emoji
    pkgs.fira-code
    pkgs.fira-code-symbols
    pkgs.open-sans
    pkgs.lmodern

    # (pkgs.nerdfonts.override {fonts = ["FiraCode"];})
    pkgs.nerd-fonts.fira-code

    inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd
  ];
}
