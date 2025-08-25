{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  env = config.modules.usrEnv;
in {
  config = mkIf env.desktop.wms.river.enable {
    # services.displayManager.sessionPackages = let
    #   session = pkgs.stdenvNoCC.mkDerivation {
    #     name = "river-wayland-session";
    #     src = pkgs.writeTextDir "entry" ''
    #       Desktop Entry]
    #       Name=River
    #       Comment=A dynamic tiling Wayland compositor
    #       Exec=river
    #       Type=Application
    #     '';
    #     dontBuild = true;

    #     installPhase = ''
    #       mkdir -p $out/share/wayland-sessions
    #       cp entry $out/share/wayland-sessions/river.desktop
    #     '';
    #     passthru.providedSessions = ["river"];
    #   };
    # in [session];

    programs.river = {
      enable = true;
      extraPackages = with pkgs; [
        i3bar-river
        wideriver
        river-bnf
        satty
        wl-clipboard
        grim
        slurp
        grimblast
        i3status-rust
      ];
    };

    xdg.portal = {
      enable = true;

      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-wlr
      ];
    };
  };
}
