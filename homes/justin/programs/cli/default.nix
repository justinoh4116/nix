{
  lib,
  pkgs,
  self,
  config,
  ...
}: {
  imports = [
    ./yazi.nix
  ];
  home.packages = with pkgs; [
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
    texliveFull

    # wayland stuff
    wl-clipboard
    grim
    slurp
  ];

  programs.git = {
    userEmail = "justinoh4116@gmail.com";
    userName = "Justin Oh";
  };
}
