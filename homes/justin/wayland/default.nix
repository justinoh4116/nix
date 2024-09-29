{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # ./dunst.nix
    ./anyrun
    ./ags
    ./xdg-portals.nix
    # ./walker
  ];

  home = {
    packages = [
      # Wallpaper
      # pkgs.swaybg
      pkgs.cliphist
      pkgs.blueman
      pkgs.grim
      pkgs.slurp
      pkgs.gradience
    ];

    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.apple-cursor;
      name = "macOS-White";
      size = 24;
    };
  };

  gtk = {
    enable = true;

    # font = {
    #   name = "SFPro Text Nerd Font";
    #   # size = 9;
    # };

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };

    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
  };

  xdg.configFile."gtk-4.0/gtk.css".enable = lib.mkForce false;

  # make some environment tweaks for wayland
  home.sessionVariables = {
    GDK_BACKEND = "wayland,x11";
    # some nixpkgs modules have wrapers
    # that force electron apps to use wayland
    NIXOS_OZONE_WL = "1";
    # make qt apps expect wayland
    QT_QPA_PLATFORM = "wayland";
    # set backend for sdl
    SDL_VIDEODRIVER = "wayland";
    # fix modals from being attached on tiling wms
    _JAVA_AWT_WM_NONREPARENTING = "1";
    # fix java gui antialiasing
    _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
    # firefox and mozilla software expect wayland
    MOZ_ENABLE_WAYLAND = "1";
  };
}
