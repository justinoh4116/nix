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
