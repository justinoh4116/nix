{
  config,
  pkgs,
  lib,
  ...
}: let
  sys = config.modules.system;
in {
  environment.systemPackages = with pkgs; [networkmanagerapplet];

  systemd.network.wait-online.enable = false;

  networking = {
    networkmanager = {
      enable = true;
    };
  };
}
