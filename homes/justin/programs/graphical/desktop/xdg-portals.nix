{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}: let
  desktop = osConfig.modules.usrEnv.desktop;
in {
  config = lib.mkIf desktop.enable {
    # xdg.portal = {
    #   enable = true;
    #   xdgOpenUsePortal = true;
    #   # wlr.enable = true;
    #   config = {
    #     common = {
    #       "org.freedesktop.impl.portal.FileChooser" = [
    #         "termfilechooser"
    #         "gtk"
    #       ];
    #       default = [
    #         # "termfilechooser"
    #         "gtk"
    #         "gnome"
    #       ];
    #     };
    #     niri = {
    #       default = [
    #         # "termfilechooser"
    #         "gtk"
    #         "gnome"
    #       ];
    #       "org.freedesktop.impl.portal.FileChooser" = [
    #         "termfilechooser"
    #         "gtk"
    #       ];
    #     };
    #   };
    # };
    # xdg.portal.extraPortals = [
    #   pkgs.xdg-desktop-portal-termfilechooser
    #   pkgs.xdg-desktop-portal-gtk
    # ];

    # xdg.configFile."xdg-desktop-portal-termfilechooser/config".source =
    #   (pkgs.formats.ini {}).generate "config"
    #   {
    #     filechooser = {
    #       cmd = "${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh";
    #       default_dir = "$HOME";
    #       env = ''TERMCMD='wezterm start -e' '';
    #       open_mode = "suggested";
    #       save_mode = "last";
    #     };
    #   };

    # xdg.portal = {
    #   enable = true;
    #
    #   extraPortals = [
    #     pkgs.xdg-desktop-portal-gtk
    #     pkgs.kdePackages.xdg-desktop-portal-kde
    #     pkgs.xdg-desktop-portal-gnome
    #   ];
    #
    #   config = {
    #     # hyprland.default = ["gtk" "hyprland"];
    #     common = let
    #       portal = "hyprland";
    #     in {
    #       default = ["gnome " "kde" "gtk"];
    #
    #       "org.freedesktop.impl.portal.Screencast" = ["gnome"];
    #
    #       # for flameshot to work
    #       # https://github.kom/flameshot-org/flameshot/issues/3363#issuecomment-1753771427
    #       # "org.freedesktop.impl.portal.Screencast" = ["${portal}"];
    #       # "org.freedesktop.impl.portal.Screenshot" = ["${portal}"];
    #     };
    #   };

    # xdg-desktop-wlr (this section) is no longer needed, xdg-desktop-portal-hyprland
    # will (and should) override this one
    # however in case I run a different compositor on a Wayland host, it can be enabled
    # wlr = {
    #   enable = mkForce (env.isWayland && env.desktop != "Hyprland");
    #   settings = {
    #     screencast = {
    #       max_fps = 30;
    #       chooser_type = "simple";
    #       chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
    #     };
    #   };
    # };
    # };
  };
}
