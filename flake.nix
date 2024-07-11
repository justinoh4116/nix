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
    ...
  }: let
    overlays = [
      # inputs.neovim-nightly-overlay.overlay.default
    ];
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    nixosConfigurations = {
      "framework" = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "x86_64-linux";
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
        # This is also not the recommended way of passing `nixpkgs`,
        # for reasons (similar to `system` above) that are out-of-scope of this example.
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./homes/justin/profile.nix
        ];
        # Just like `specialArgs` above...
        extraSpecialArgs = {
          inherit inputs;
          # ...
        };
      };
      # ...
    };
  };
  inputs = {
    # stable?!? hardly even
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    systems.url = "github:nix-systems/default";

    schizofox.url = "github:schizofox/schizofox";

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1&ref=refs/tags/v0.41.2";
    };
    hyprland-plugins = {
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
    # xdg-portal-hyprland = {
    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";
    #   inputs.hyprland.follows = "hyprland";
    # };
    # hyprpicker = {
    hyprpicker.url = "github:hyprwm/hyprpicker";
    #   inputs.hyprland.follows = "hyprland";
    # };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
    };

    hypridle.url = "github:hyprwm/hypridle";

    hy3 = {
      url = "github:outfoxxed/hy3?ref=hl0.41.2";
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

    walker.url = "github:abenz1267/walker";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    gestures.url = "github:riley-martin/gestures";

    # apple fonts
    apple-fonts.url = "github:LYndeno/apple-fonts.nix";

    # keyboard remapping tool
    kmonad.url = "github:kmonad/kmonad?dir=nix";
  };
}
