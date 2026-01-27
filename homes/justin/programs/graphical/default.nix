{
  inputs,
  pkgs,
  self,
  lib,
  osConfig,
  ...
}: {
  imports = [
    ./desktop
    ./floorp.nix
    ./zathura.nix
    ./discord.nix
    # ./schizofox.nix
    ./zen.nix
  ];

  config = lib.mkIf osConfig.modules.system.programs.gui.enable {
    home.packages = with pkgs;
      [
        gamescope
        # kiwitalk
        # blender
        remmina
        vscode
        tailscale
        webcord
        graphviz
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
  };
}
