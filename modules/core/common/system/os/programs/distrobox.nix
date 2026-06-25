{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.system.programs.distrobox;
in {
  config = lib.mkIf cfg.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = lib.mkDefault true;
    };

    environment.systemPackages = [pkgs.distrobox];
  };
}
