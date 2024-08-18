{
  description = "flakey";

  outputs = inputs @ {
    systems,
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    hyprland,
    hy3,
    nixpkgs-freecad,
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
    pkgs-freecad-fix = import nixpkgs-freecad {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    nixosConfigurations = {
      "framework" = nixpkgs.lib.nixosSystem {
        # system = "x86_64-linux";

        specialArgs = {inherit inputs;};
        modules = [
          # Import the configuration.nix here, so that the
          # old configuration file can still take effect.
          # Note: configuration.nix itself is also a Nixpkgs Module,
          # /etc/nixos/configuration.nix
          # /etc/nixos/hardware-configuration.nix
          nixos-hardware.nixosModules.framework-13-7040-amd
          ./hosts/framework
        ];
      };

      "nixos" = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "x86_64-linux";
        modules = [
          # Import the configuration.nix here, so that the
          # old configuration file can still take effect.
          # Note: configuration.nix itself is also a Nixpkgs Module,
          ./configuration.nix
          ./hosts/nix-test
        ];
      };
    };
    homeConfigurations = {
      justin = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        # This is also not the recommended way of passing `nixpkgs`,
        # for reasons (similar to `system` above) that are out-of-scope of this example.
        # home-manager.useGlobalPkgs = true;
        #pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./homes/justin/profile.nix
        ];
        # Just like `specialArgs` above...
        extraSpecialArgs = {
          inherit inputs;
          inherit pkgs-freecad-fix;
        };
      };
      # ...
    };
  };
  inputs = {
    # stable?!? hardly even
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-2405.url = "github:NixOS/nixpkgs/nixos-24.05";

    # pin fixed freecad
    nixpkgs-freecad.url = "github:squalus/nixpkgs/freecad";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

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
      # url = "git+https://github.com/hyprwm/Hyprland?submodules=1"; #&ref=refs/tags/v0.42.0";
      type = "git";
      url = "https://github.com/hyprwm/hyprland";
      submodules = true;
      # inputs.aquamarine.follows = "aquamarine";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # aquamarine = {
    #   url = "github:Hyprwm/aquamarine";
    #   inputs.nixpkgs.follows = "nixpkgs-2405";
    # };
    hyprland-plugins = {
      url = "git+https://github.com/hyprwm/hyprland-plugins?rev=98cb18c6fcfe8196ef4150d09fbae305b7bb2954";
      inputs.hyprland.follows = "hyprland";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
    };
    # hyprcursor = {
    #   url = "github:hyprwm/hyprcursor";
    #   inputs.hyprland.follows = "hyprland";
    # };
    # xdg-portal-hyprland = {
    xdg-portal-hyprland = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      inputs.hyprland.follows = "hyprland";
    };
    # hyprpicker = {
    hyprpicker.url = "github:hyprwm/hyprpicker";
    #   inputs.hyprland.follows = "hyprland";
    # };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
    };

    hypridle.url = "github:hyprwm/hypridle";

    hy3 = {
      url = "github:outfoxxed/hy3"; #"?ref=hl0.42.0";
      inputs.hyprland.follows = "hyprland";
    };

    hyprfocus = {
      url = "github:pyt0xic/hyprfocus";
      inputs.hyprland.follows = "hyprland";
    };

    # aylur's gtk shell
    ags.url = "github:Aylur/ags";

    # anyrun launcher
    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tailray = {
      url = "github:NotAShelf/tailray";
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
}
