{
  fileSystems = {
    "/" = {
      device = "zpool/local/root";
      fsType = "zfs";
      options = ["zfsutil"];
    };

    "/nix" = {
      device = "zpool/local/nix";
      fsType = "zfs";
      options = ["zfsutil"];
    };

    "/home" = {
      device = "zpool/safe/home";
      fsType = "zfs";
      options = ["zfsutil"];
      neededForBoot = true;
    };

    "/persist" = {
      device = "zpool/safe/persist";
      fsType = "zfs";
      options = ["zfsutil"];
      neededForBoot = true;
    };

    "/boot" = {
      device = "/dev/disk/by-id/nvme-SHGP31-2000GM_AJCBN40061010B462-part5";
      fsType = "vfat";
    };
  };

  swapDevices = [{device = "/dev/disk/by-id/nvme-SHGP31-2000GM_AJCBN40061010B462-part7";}];
}
