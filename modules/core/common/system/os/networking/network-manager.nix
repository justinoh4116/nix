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
      plugins = [
        pkgs.networkmanager-l2tp
      ];
    };
  };

  services.strongswan = {
    enable = true;
    secrets = [
      "ipsec.d/ipsec.nm-l2tp.secrets"
    ];
  };
}
