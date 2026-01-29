{
  boot.initrd.luks.devices = {
    # cryptkey = {
    #   device = "/dev/disk/by-uuid/ce0bc6d7-b549-4ae0-a2b1-c79927deb902";
    # };
    cryptroot = {
      device = "/dev/disk/by-uuid/5de132e4-ab0d-4364-af20-1cf7ce41d5bf";
      # keyFile = "/dev/mapper/cryptkey"; password can unlock all w/ one entry
    };
    cryptswap = {
      device = "/dev/disk/by-uuid/86594f29-e2a5-49c9-8e98-ccd71cbdb296";
      # keyFile = "/dev/mapper/cryptkey";
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/4bdf20db-7b0b-4d99-bf7e-ca62589d717d";
    fsType = "btrfs";
    options = ["subvol=local/root" "noatime"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/4bdf20db-7b0b-4d99-bf7e-ca62589d717d";
    fsType = "btrfs";
    options = ["subvol=safe/home" "noatime"];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/4bdf20db-7b0b-4d99-bf7e-ca62589d717d";
    fsType = "btrfs";
    options = ["subvol=safe/persist" "noatime"];
    neededForBoot = true;
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/4bdf20db-7b0b-4d99-bf7e-ca62589d717d";
    fsType = "btrfs";
    options = ["subvol=local/log" "noatime"];
    neededForBoot = true;
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/4bdf20db-7b0b-4d99-bf7e-ca62589d717d";
    fsType = "btrfs";
    options = ["subvol=local/nix" "noatime"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B718-9704";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/499b1e06-802e-47e0-a1fa-995bd139b649";}
  ];
}
