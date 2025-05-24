{
  self,
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  services = {
    sanoid = {
      enable = true;
      datasets."zpool/safe" = {
        autosnap = true;
        autoprune = true;
        recursive = true;
        frequently = 8;
        hourly = 24;
        daily = 7;
        weekly = 12;
      };
    };
    zfs = {
      autoScrub.enable = true;
    };
  };
}
