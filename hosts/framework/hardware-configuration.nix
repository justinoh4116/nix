# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices = {
    "cryptkey" = {
      device = "/dev/disk/by-uuid/b1c4f6b5-f1a1-457f-bc2b-10af7b7f2a5f";
    };

    "cryptroot" = {
      device = "/dev/disk/by-uuid/0995a747-04ad-4064-b3f8-a2cc9a87b075";
      keyFile = "/dev/mapper/cryptkey";
      keyFileSize = 8192;
    };

    "cryptswap" = {
      device = "/dev/disk/by-uuid/d4caf0b8-bba0-45db-bb54-c11e09863d95";
      keyFile = "/dev/mapper/cryptkey";
      keyFileSize = 8192;
    };
  };

  fileSystems."/" =
    { device = "UUID=fb89c17d-8113-4626-bca6-abb7db4a65d0";
      fsType = "bcachefs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/CD31-4904";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/b57afdff-ef2b-4117-8819-a5669393bf4e"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
