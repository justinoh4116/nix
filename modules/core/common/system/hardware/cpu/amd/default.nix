{
  config,
  pkgs,
  lib,
  ...
}: let
  dev = config.modules.device;
in {
  config = lib.mkIf ((builtins.elem dev.cpu.type ["amd" "vm-amd"]) && !lib.isWSL config) {
    environment.systemPackages = [pkgs.amdctl];

    hardware.cpu.amd.updateMicrocode = true;

    boot = lib.mkMerge [
      {
        # Always load the kvm-amd module for Virtualization
        # bellow modules allow for Virtualization on AMD cpus
        # `"iommu=pt"` kernel parameter can be passed to remove
        # IOMMU overhead
        kernelModules = ["kvm-amd"];
        kernelParams = ["amd_iommu=on"];
      }

      (lib.mkIf (lib.isx86Linux pkgs) {
        kernelModules = [
          "amd-pstate" # load pstate module in case the device has a newer gpu
          "zenpower" # zenpower is for reading cpu info, i.e voltage
          "msr" # x86 CPU MSR access device
        ];

        extraModulePackages = [config.boot.kernelPackages.zenpower];
      })
    ];
  };
}
