{pkgs, ...}: {
  imports = [
    ./codex.nix
    ./t3code.nix
    ./headroom.nix
  ];
  config = {
    home.packages = with pkgs; [
      rtk
      pi-coding-agent
      worktrunk
    ];
  };
}
