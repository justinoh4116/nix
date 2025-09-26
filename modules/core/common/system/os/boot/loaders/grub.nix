{
  config,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkIf optionalAttrs;

  sys = config.modules.system;
in {
  config = mkIf (sys.boot.loader == "grub") {
    boot.loader.grub = {
      enable = true;
      zfsSupport = sys.fs.zfs.enable;
      efiSupport = true;
      # efiInstallAsRemovable = true;
      #device = "nodev";
      mirroredBoots = [
        {
          devices = ["nodev"];
          path = "/boot";
        }
      ];
    };
  };
}
