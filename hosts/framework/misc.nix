{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: let
  pkgs-hyprland = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  environment.systemPackages = with pkgs; [
    # ydotool
    just
  ];

  environment.etc."flake-source".source = inputs.self;

  age.secrets."nix-access-tokens-github" = {
    file = ../../secrets/nix-access-tokens-github.age;
    group = config.users.groups.keys.name;
    mode = "0440";
  };

  # programs.ydotool.enable = true;

  hardware = {
    bluetooth = {
      enable = true;
      input.General.ClassicBondedOnly = false;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          AutoEnable = true;
          ControllerMode = "bredr";
        };
      };
    };

    opengl.enable = true;
    # graphics = {
    #   enable = true;
    #   package = pkgs-hyprland.mesa.drivers;
    #
    #   # 32 bit support
    #   driSupport32Bit = true;
    #   package32 = pkgs.hyprland.pkgsi686Linux.mesa.drivers;
    # };
  };

  security.pam.services.hyprlock = {};

  services = {
    geoclue2 = {
      enable = true;
      enableWifi = false;
      enable3G = false;
    };
    hardware.bolt.enable = true;

    # automatic-timezoned.enable = true;

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

  nix = {
    extraOptions = ''
      !include ${config.age.secrets.nix-access-tokens-github.path}
    '';
    settings = {
      substituters = [
        "https://hyprland.cachix.org"
        "https://anyrun.cachix.org"
        "https://walker.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
      ];
    };
  };
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };
  # nixpkgs.overlays = [
  #   # inputs.neovim-nightly-overlay.overlay.default
  # ];
}
