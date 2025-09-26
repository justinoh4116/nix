{
  fileSystems."/" = {
    device = "zpool/local/root";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "zpool/local/nix";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "zpool/safe/home";
    fsType = "zfs";
  };

  fileSystems."/persist" = {
    device = "zpool/safe/persist";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/997E-90C8";
    fsType = "vfat";
  };

  swapDevices = [];
}
