{
  inputs,
  pkgs,
  self,
  lib,
  pkgs-freecad-fix,
  ...
}: {
  imports = [
    ./discord.nix
    ./nextcloud.nix
    ./schizofox.nix
  ];

  home.packages = with pkgs;
    [
      graphviz
      anydesk
      netflix
      parsec-bin
      networkmanagerapplet
      vlc
      qbittorrent
      imv
      inkscape
      mpv
      libsForQt5.okular
      libsForQt5.dolphin
      pcmanfm
      arduino
      #kicad
      zoom-us
      #printrun
      tetrio-desktop
      prusa-slicer
      xournalpp
      zathura
      obs-studio
      spotify
      obsidian
      zotero
      ungoogled-chromium
      # freecad
    ]
    ++ [
      pkgs-freecad-fix.freecad
    ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];
}
