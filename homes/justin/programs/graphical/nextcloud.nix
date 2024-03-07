{
  inputs,
  pkgs,
  self,
  lib,
  config,
  ...
}: {
  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };
}
