{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) listOf str;
in {
  options.modules.system.fs = {
    btrfs = {
      enable = mkEnableOption "btrfs filesystem";
    };
    zfs = {
      enable = mkEnableOption "zfs fs stuff";
      autoScrub = mkEnableOption "auto scrub of zfs pools";
      poolsToImport = mkOption {
        type = listOf str;
        description = "zpools to auto import on boot";
      };
      snapshots = mkEnableOption "sanoid snapshotting";
    };
  };
}
