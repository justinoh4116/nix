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
    networkmanagerapplet
    vlc
    qbittorrent
    imv
    inkscape
    mpv
    kdePackages.okular
    kdePackages.dolphin
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
