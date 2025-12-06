{
  osConfig,
  pkgs,
  inputs,
  lib,
  ...
}: let
  cfg = osConfig.modules.usrEnv.services.syncthing;
in {
  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      # user = "justin";
      # group = "justin";
      # dataDir = "/home/justin/syncthing_test";
      # configDir = "/home/justin/.config/syncthing";
      key = cfg.key;
      cert = cfg.cert;

      openDefaultPorts = true;
      overrideDevices = true;
      overrideFolders = true;

      # tray.enable = true;

      settings = {
        folders = cfg.folders;
        devices = cfg.devices;
      };
    };
  };
}
