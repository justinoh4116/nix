{
  config,
  lib,
  ...
}: let
  sys = config.modules.system;
  cfg = sys.fs.btrfs;
in {
  config = lib.mkIf (cfg.enable && cfg.snapshots) {
    fileSystems."/btrfs" = {
      device = config.fileSystems."/".device;
      fsType = "btrfs";
      options = ["subvol=/" "noatime"];
    };

    # snapshots in safe are real snapshots
    # snapshots in local are old roots

    systemd.tmpfiles.rules = [
      "d /btrfs/safe/snapshots 0755 root root -"
      "d /btrfs/safe/snapshots/home 0755 root root -"
      "d /btrfs/safe/snapshots/persist 0755 root root -"
    ];

    services.btrbk.instances.safe = {
      onCalendar = "*:0/15";
      snapshotOnly = true;
      settings = {
        timestamp_format = "long";
        snapshot_preserve_min = "24h";
        snapshot_preserve = "14d 8w 12m";

        volume."/btrfs" = {
          subvolume."safe/home" = {
            snapshot_dir = "safe/snapshots/home";
          };

          subvolume."safe/persist" = {
            snapshot_dir = "safe/snapshots/persist";
          };
        };
      };
    };
  };
}
