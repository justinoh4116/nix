{
  inputs,
  lib,
  pkgs,
  self,
  ...
}: {
  environment.systemPackages = with pkgs; [
    just
  ];

  hardware.bluetooth.enable = true;

  services = {
    printing = {
      enable = true;
    };
    avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
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
  nixpkgs.overlays = [
    inputs.neovim-nightly-overlay.overlay
  ];
}
