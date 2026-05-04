{pkgs, ...}: {
  config = {
    environment.systemPackages = with pkgs; [
      git
      btop
      tmux
      ripgrep
      fd
      bat
      fzf
    ];
  };
}
