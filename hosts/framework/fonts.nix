{
  self,
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  fonts.packages = [
    pkgs.work-sans
    pkgs.dejavu_fonts
    pkgs.noto-fonts
    pkgs.noto-fonts-color-emoji
    pkgs.fira-code
    pkgs.fira-code-symbols
    pkgs.open-sans
    pkgs.lmodern

    pkgs.baekmuk-ttf
    pkgs.unfonts-core
    pkgs.source-han-sans
    pkgs.noto-fonts-cjk-sans

    # (pkgs.nerdfonts.override {fonts = ["FiraCode"];})
    pkgs.nerd-fonts.fira-code

    inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd
  ];
}
