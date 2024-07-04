{
  inputs,
  lib,
  pkgs,
  self,
  ...
}: {
  environment.systemPackages = with pkgs; [
    ydotool
    just
  ];

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    opengl.enable = true;
  };

  security.pam.services.hyprlock = {};

  services = {
    geoclue2 = {
      enable = true;
      enableWifi = false;
      enable3G = false;
    };
    hardware.bolt.enable = true;

    automatic-timezoned.enable = true;

    upower.enable = true;

    printing = {
      enable = true;
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    fwupd.enable = true;

    fwupd.package =
      (import (builtins.fetchTarball {
          url = "https://github.com/NixOS/nixpkgs/archive/bb2009ca185d97813e75736c2b8d1d8bb81bde05.tar.gz";
          sha256 = "sha256:003qcrsq5g5lggfrpq31gcvj82lb065xvr7bpfa8ddsw8x4dnysk";
        }) {
          inherit (pkgs) system;
        })
      .fwupd;

    fprintd = {
      enable = true;
      # tod.enable = true;
      # tod.driver = pkgs.libfprint-2-tod1-goodix;
    };

    blueman = {
      enable = true;
    };
  };

  nix.settings = {
    substituters = [
      "https://hyprland.cachix.org"
      "https://anyrun.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    ];
  };
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };
  # nixpkgs.overlays = [
  #   # inputs.neovim-nightly-overlay.overlay.default
  # ];
}
