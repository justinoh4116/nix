{
  boot.zfs.extraPools = ["zboot" "zdata"];
  fileSystems."/" =
    { device = "zboot/local/root";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    { device = "zboot/local/nix";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "zboot/safe/home";
      fsType = "zfs";
    };

  fileSystems."/data" =
    { device = "zdata/safe/data";
      fsType = "zfs";
    };

  fileSystems."/persist" =
    { device = "zboot/safe/persist";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/7455-439B";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/d87741cc-82d3-4304-8e63-369d08acda55"; }
    ];
}
