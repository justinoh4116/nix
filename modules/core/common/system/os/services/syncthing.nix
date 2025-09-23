{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  cfg = config.modules.system.services.syncthing;
in {
  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
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
