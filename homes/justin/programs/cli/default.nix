{
  lib,
  pkgs,
  self,
  config,
  ...
}: {
  imports = [
  ];
  home.packages = with pkgs; [
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
    gcc
    brightnessctl
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
