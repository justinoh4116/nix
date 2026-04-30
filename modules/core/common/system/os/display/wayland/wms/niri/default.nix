{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  # pkgs-niri = inputs.niri-flake.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  sys = config.modules.system;
  env = config.modules.usrEnv;
  cfg = env.desktop.wms.niri;
in {
  imports = [
    inputs.niri-flake.nixosModules.niri
  ];

  config = lib.mkIf (env.desktop.wm == "niri" && sys.video.enable) {
    nixpkgs.overlays = [inputs.niri-flake.overlays.niri];

    services.displayManager.gdm = {
      enable = true;
      autoSuspend = false;
      wayland = true;
    };

    programs.niri = {
      enable = true;
      package = inputs.niri-flake.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;
    };

    environment.systemPackages = [
      pkgs.xwayland-satellite
    ];

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      # wlr.enable = true;
      config = {
        # note that setting config here overwrites whatever the niri module sets
        common = {
          "org.freedesktop.impl.portal.FileChooser" = [
            "termfilechooser"
            "gtk"
          ];
          default = [
            # "termfilechooser"
            "gtk"
            "gnome"
          ];
        };
        niri = {
          default = [
            # "termfilechooser"
            "gtk"
            "gnome"
          ];
          "org.freedesktop.impl.portal.FileChooser" = [
            "termfilechooser"
            "gtk"
          ];
        };
      };
    };
    xdg.portal.extraPortals = [
      pkgs.xdg-desktop-portal-termfilechooser
      pkgs.xdg-desktop-portal-gtk
    ];

    # hardware.graphics.package = pkgs-niri.mesa.drivers;
  };
}
