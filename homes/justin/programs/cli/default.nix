{
  lib,
  inputs,
  pkgs,
  self,
  config,
  ...
}: {
  imports = [
    ./git
    ./latex.nix
    ./yazi.nix

    ./zellij
  ];
  home.packages = with pkgs;
    [
      just
      spotify-player
      maestral
      maestral-gui
      # poetry
      eza
      playerctl
      dmenu
      openssl
      ranger
      screen
      llvm
      arduino-cli
      pfetch-rs
      acpi
      cmake
      rustup
      fzf
      file
      unzip
      ripgrep
      fd
      fastfetch
      rustup
      brightnessctl
      gcc

      # wayland stuff
      wl-clipboard
      grim
      slurp
    ]
    ++ [inputs.agenix.packages.${pkgs.system}.default];

  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      # enableFishIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
