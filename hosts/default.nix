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

    coreModules = modulePath + /core;
    options = modulePath + /options;

    common = coreModules + /common;

    # roles
    laptop = coreModules + /roles/laptop;
    workstation = coreModules + /roles/workstation;

    # import home-manager and home-manager configs together
    homes = [hm homesPath];

    # mkModulesFor generates a list of modules to be imported by any host with
    # a given hostname. Do note that this needs to be called *in* the nixosSystem
    # set, since it generates a *module list*, which is also expected by system
    # builders.
    mkModulesFor = hostname: {
      moduleTrees ? [options common],
      roles ? [],
      extraModules ? [],
    } @ args:
      flatten (
        concatLists [
          # Derive host specific module path from the first argument of the
          # function. Should be a string, obviously.
          (singleton ./${hostname}/host.nix)

          # Recursively import all module trees (i.e. directories with a `module.nix`)
          # for given moduleTree directories, and in addition, roles.
          (map (path: mkModuleTree' {inherit path;}) (concatLists [moduleTrees roles]))

          # And append any additional lists that don't don't conform to the moduleTree
          # API, but still need to be imported somewhat commonly.
          args.extraModules
        ]
      );
  in {
    framework = mkNixosSystem {
      inherit withSystem;
      hostname = "framework";
      system = "x86_64-linux";
      modules = mkModulesFor "framework" {
        roles = [laptop workstation];
        extraModules = [
          homes
          agenix
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
      modules = [
        ./titanic
        agenix
      ];
    };
  };
}
