{
  config,
  lib,
  ...
}: let
  prg = config.modules.system.programs;
in {
  config = lib.mkIf prg.steam.enable {
    # config = {
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

    programs.steam = {
      enable = true;
    };
  };
}
