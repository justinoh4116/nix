{
  inputs,
  self,
  pkgs,
  config,
  lib,
  ...
}: {
  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs:
        with pkgs; [
          love
          zlib
          dbus
          freetype
          glib
          atk
          cairo
          pango
          fontconfig
          libpng
          icu
        ];
    };
  };
  nixpkgs.config.allowUnfreePredicate = _: true;

  programs.steam = {
    enable = true;
  };
}
