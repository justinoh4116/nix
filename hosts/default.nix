# code below heavily inspired by https://github.com/notashelf/nyx
{
  withSystem,
  inputs,
  ...
}: {
  flake.nixosConfigurations = let
    inherit (inputs.self) lib;
    inherit (lib) mkNixosIso mkNixosSystem mkModuleTree';
    inherit (lib.lists) concatLists flatten singleton;

    hm = inputs.home-manager.nixosModules.home-manager; # home manager
    hw = inputs.nixos-hardware.nixosModules; # hardware config for laptop and other weird devices
    agenix = inputs.agenix.nixosModules.default; # secret management

    modulePath = ../modules;

    homesPath = ../homes;

    # import home-manager and home-manager configs together
    homes = [hm homesPath];

    mkModulesFor = hostname: {extraModules ? []} @ args:
      flatten (
        concatLists [
          # Derive host specific module path from the first argument of the
          # function. Should be a string, obviously.
          (singleton ./${hostname}/default.nix)

          args.extraModules
        ]
      );

  in {
    framework = mkNixosSystem {
      inherit withSystem;
      hostname = "framework";
      system = "x86_64-linux";
      modules = mkModulesFor "framework" {
        extraModules = [
          homes
          agenix
          inputs.lanzaboote.nixosModules.lanzaboote
          hw.framework-13-7040-amd
        ];
      };
    };
    iceberg = mkNixosSystem {
      inherit withSystem;
      hostname = "iceberg";
      system = "x86_64-linux";
      modules = mkModulesFor "iceberg" {
        extraModules = [
          agenix
        ];
      };
    };
    titanic = mkNixosSystem {
      inherit withSystem;
      hostname = "titanic";
      system = "x86_64-linux";
      modules = mkModulesFor "titanic" {
        extraModules = [
          agenix
        ];
      };
    };
  };
}
