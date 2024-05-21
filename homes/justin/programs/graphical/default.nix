{
  inputs,
  pkgs,
  self,
  lib,
  ...
}: {
  imports = [
    ./discord.nix
    ./nextcloud.nix
    ./schizofox.nix
  ];

  home.packages = with pkgs; [
    inkscape
    mpv
    libsForQt5.okular
    libsForQt5.dolphin
    pcmanfm
    arduino
    kicad
    zoom-us
    printrun
    tetrio-desktop
    prusa-slicer
    xournalpp
    zathura
    obs-studio
    spotify
    obsidian
    zotero
    ungoogled-chromium
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];
}
