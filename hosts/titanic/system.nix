{
  config,
  inputs,
  lib,
  ...
}: {
  imports = [
    ../../modules/zfs.nix
  ];

  age.secrets.zfs-pushover-token.file = ../../secrets/zfs-pushover-token.age;
  age.secrets.zfs-pushover-user-key.file = ../../secrets/pushover-user-key.age;

  modules.zfs = {
    enable = true;
    enableNotifications = true;
    pushoverTokenPath = config.age.secrets.zfs-pushover-token.path;
    pushoverUserKeyPath = config.age.secrets.zfs-pushover-user-key.path;
  };
}
