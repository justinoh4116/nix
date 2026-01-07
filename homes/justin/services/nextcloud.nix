{
  inputs,
  pkgs,
  self,
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.modules.usrEnv.services.nextcloud-client.enable {
    services.nextcloud-client = {
      enable = true;
      startInBackground = true;
    };
  };
}
