{
  config,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkIf optionalAttrs isWSL;

  sys = config.modules.system;
in {
  config = mkIf ((sys.boot.loader == "grub") && !isWSL config) {
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
