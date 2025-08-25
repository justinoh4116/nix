{inputs, self, ...}: {
  perSystem = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cachix-deploy-lib = inputs.cachix-deploy-flake.lib pkgs;
  in {
    packages = {
      cachix-deploy-iceberg = cachix-deploy-lib.spec {
        agents = {
          iceberg = self.nixosConfigurations.iceberg.config.system.build.toplevel;
        };
      };
      cachix-deploy-framework = cachix-deploy-lib.spec {
        agents = {
          framework = self.nixosConfigurations.framework.config.system.build.toplevel;
        };
      };
    } // lib.packagesFromDirectoryRecursive {
        inherit (pkgs) callPackage;
        directory = ./packages;
      };
  };
}
