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
    ./steam.nix
  ];

  home.packages = with pkgs; [
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
