{pkgs, ...}: {
  imports = [
    ./codex.nix
    ./t3code.nix
    ./headroom.nix
  ];
  config = {
    home.packages = with pkgs; [
      rtk
    ];
  };
}
