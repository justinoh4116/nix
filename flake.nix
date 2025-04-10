{
  description = "flakey";

  inputs = {
    # stable?!? hardly even
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-2405.url = "github:NixOS/nixpkgs/nixos-24.05";

    cachix-deploy-flake.url = "github:cachix/cachix-deploy-flake";

    # nix user repositories
    nur.url = "github:nix-community/NUR";

    agenix.url = "github:ryantm/agenix";

    microvm.url = "github:astro/microvm.nix";

    # pin fixed freecad
    # nixpkgs-freecad.url = "github:squalus/nixpkgs/freecad";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    systems.url = "github:nix-systems/default";

    schizofox.url = "github:schizofox/schizofox";

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1&ref=refs/tags/v0.48.0";
      # type = "git";
      # url = "https://github.com/hyprwm/hyprland";
      # submodules = true;
      # rev = "04ac46c54357278fc68f0a95d26347ea0db99496";
      inputs.aquamarine.follows = "aquamarine";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    aquamarine = {
      url = "github:Hyprwm/aquamarine";
      # inputs.nixpkgs.follows = "nixpkgs-2405";
    };
    hyprland-plugins = {
      # url = "git+https://github.com/hyprwm/hyprland-plugins?rev=98cb18c6fcfe8196ef4150d09fbae305b7bb2954";
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
    };
    # hyprcursor = {
    #   url = "github:hyprwm/hyprcursor";
    #   inputs.hyprland.follows = "hyprland";
    # };
    xdg-portal-hyprland = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
    };

    hyprpicker.url = "github:hyprwm/hyprpicker";

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
    };

    hypridle.url = "github:hyprwm/hypridle";

    hy3 = {
      url = "github:outfoxxed/hy3?ref=hl0.48.0";
      inputs.hyprland.follows = "hyprland";
    };

    hyprfocus = {
      url = "github:pyt0xic/hyprfocus";
      inputs.hyprland.follows = "hyprland";
    };

    # aylur's gtk shell
    ags.url = "github:Aylur/ags/v1";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    # anyrun launcher
    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tailray = {
      url = "github:NotAShelf/tailray";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pyprland.url = "github:hyprland-community/pyprland";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    gestures.url = "github:riley-martin/gestures";

    # apple fonts
    apple-fonts.url = "github:LYndeno/apple-fonts.nix";

    # keyboard remapping tool
    kmonad.url = "github:kmonad/kmonad?dir=nix";
  };

  outputs = inputs @ {
    systems,
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    hyprland,
    hy3,
    nur,
    nixpkgs-2405,
    lanzaboote,
    agenix,
    cachix-deploy-flake,
    ...
  }: let
    overlays = [
      # inputs.neovim-nightly-overlay.overlay.default
    ];
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    pkgs-stable = import nixpkgs-2405 {
      inherit system;
      config.allowUnfree = true;
    };
    cachix-deploy-lib = cachix-deploy-flake.lib pkgs;
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    nixosConfigurations = {
      "framework" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {
          inherit inputs;
          inherit pkgs-stable;
        };
        modules = [
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.justin = import ./homes/justin/profile.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit pkgs-stable;
            };
          }

          lanzaboote.nixosModules.lanzaboote
          # nur.modules.nixos.default
          # nur.legacyPackages."${system}".repos.clefru.minionpro
          nixos-hardware.nixosModules.framework-13-7040-amd
          ./hosts/framework
          agenix.nixosModules.default
        ];
      };

      "iceberg" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {
          inherit inputs;
          inherit pkgs-stable;
        };

        modules = [
          ./hosts/iceberg
          agenix.nixosModules.default
        ];
      };
    };

    packages.${system} = with pkgs; {
      cachix-deploy-spec = cachix-deploy-lib.spec {
        agents = {
          # framework = self.nixosConfigurations.framework.config.system.build.toplevel;
          iceberg = self.nixosConfigurations.iceberg.config.system.build.toplevel;
        };
      };
    };

    # homeConfigurations = {
    #   justin = home-manager.lib.homeManagerConfiguration {
    #     inherit pkgs;
    #     # This is also not the recommended way of passing `nixpkgs`,
    #     # for reasons (similar to `system` above) that are out-of-scope of this example.
    #     # home-manager.useGlobalPkgs = true;
    #     #pkgs = nixpkgs.legacyPackages.x86_64-linux;
    #     modules = [
    #       ./homes/justin/profile.nix
    #       #nur.modules.nixos.default
    #     ];
    #     # Just like `specialArgs` above...
    #     extraSpecialArgs = {
    #       inherit inputs;
    #       inherit pkgs-stable;
    #     };
    #   };
    #   # ...
    # };
  };
}
