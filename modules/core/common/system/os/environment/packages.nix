{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    neovim
    rsync
    git
    wget
    curl
    tldr
  ];
}
