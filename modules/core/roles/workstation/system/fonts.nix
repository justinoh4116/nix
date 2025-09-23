{
  lib,
  pkgs,
  inputs,
  ...
}: {
  fonts = {
    fontconfig = {
      enable = true;
      antialias = true;
      hinting.enable = true;
    };

    fontDir = {
      enable = true;
      decompressFonts = true;
    };

    packages = with pkgs; [
      work-sans
      dejavu_fonts
      noto-fonts
      noto-fonts-emoji
      fira-code
      fira-code-symbols
      open-sans
      lmodern

      baekmuk-ttf
      unfonts-core
      source-han-sans
      noto-fonts-cjk-sans

      # (pkgs.nerdfonts.override {fonts = ["FiraCode"];})
      nerd-fonts.fira-code

      inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd
    ];
  };
}
