{
  self,
  inputs,
  lib,
  pkgs,
  ...
}: {
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
  networking.firewall = {
    trustedInterfaces = ["tailscale0"];
    # required to connect to Tailscale exit nodes
    checkReversePath = "loose";
  };

  # inter-machine VPN
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  programs.ssh.startAgent = true;

  # automatic garbage collection
  nix.gc = {
    randomizedDelaySec = "15min";
    automatic = true;
    dates = "weekly";
  };
  # xdg.portal = {
  #   enable = true;
  #   configPackages = [inputs.hyprland.packages.${pkgs.system}.hyprland];
  #   extraPortals = [
  #     (inputs.xdg-portal-hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland.override {
  #       hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland;
  #     })
  #   ];
  # };
}
