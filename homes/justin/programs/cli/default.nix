{
  lib,
  pkgs,
  self,
  config,
  ...
}: {
  imports = [
    ./latex.nix
    ./yazi.nix
  ];
  home.packages = with pkgs; [
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
  ];

  programs = {
    git = {
      userEmail = "justinoh4116@gmail.com";
      userName = "Justin Oh";
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      # enableFishIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
