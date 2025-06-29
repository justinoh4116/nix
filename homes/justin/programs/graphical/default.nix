{
  inputs,
  pkgs,
  self,
  lib,
  pkgs-stable,
  ...
}: {
  imports = [
    ./zathura.nix
    ./discord.nix
    ./nextcloud.nix
    ./schizofox.nix
    ./zen.nix
  ];

  home.packages = with pkgs;
    [
      google-chrome
      spacedrive
      gamescope
      # kiwitalk
      # blender
      remmina
      vscode
      tailscale
      thunderbird
      p3x-onenote
      webcord
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
      pcmanfm
      arduino
      # kicad
      zoom-us
      #printrun
      tetrio-desktop
      prusa-slicer
      xournalpp
      obs-studio
      spotify
      obsidian
      zotero
      ungoogled-chromium
      freecad

      bitwarden-desktop

      kdePackages.dolphin
      kdePackages.dolphin-plugins
      kdePackages.ark
      kdePackages.kio
      kdePackages.kio-extras
      kdePackages.kimageformats
      kdePackages.kdegraphics-thumbnailers
      kdePackages.breeze
      libsForQt5.qt5ct

      # Okular needs ghostscript to import PostScript files as PDFs
      # so we add ghostscript_headless as a dependency
      (symlinkJoin {
        name = "Okular";
        paths = with pkgs; [
          kdePackages.okular
          ghostscript_headless
        ];
      })
    ]
    ++ [
      # pkgs-stable.spotify
    ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];
}
