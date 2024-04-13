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
    libsForQt5.okular
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
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];
}
