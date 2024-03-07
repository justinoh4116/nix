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
}
