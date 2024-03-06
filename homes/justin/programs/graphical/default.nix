{
  inputs,
  pkgs,
  self,
  lib,
  ...
}:
{
  imports = [
    ./discord.nix
    ./nextcloud.nix
    ./schizofox.nix
  ];

  home.packages = with pkgs; [
    zathura
    obs-studio
    obsidian
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];
}
