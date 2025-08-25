{
  self,
  pkgs,
  inputs,
  ...
}: let
  cachix-deploy-lib = inputs.cachix-deploy-flake.lib pkgs;
in
  cachix-deploy-lib.spec {
    agents = {
      # framework = self.nixosConfigurations.framework.config.system.build.toplevel;
      iceberg = self.nixosConfigurations.iceberg.config.system.build.toplevel;
    };
  }
