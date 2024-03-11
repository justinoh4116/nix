{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./dunst.nix
    ./anyrun
    ./ags
  ];

  home = {
    packages = [
      # Wallpaper
      # pkgs.swaybg
      pkgs.blueman
      pkgs.grim
      pkgs.slurp
    ];

    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.apple-cursor;
      name = "macOS-Monterey-White";
      size = 24;
    };
  };

  gtk = {
    enable = true;
    theme.name = "Adwaita-dark";
  };

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
