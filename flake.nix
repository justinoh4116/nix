{
  description = "flakey";

  outputs = { systems, self, nixpkgs, home-manager, ... }@inputs:
    {
      nixosConfigurations = {
        specialArgs = { inherit inputs; };
        "nixos" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
  
            # Import the configuration.nix here, so that the
            # old configuration file can still take effect.
            # Note: configuration.nix itself is also a Nixpkgs Module,
            ./configuration.nix
          ];
        };
      };
      homeConfigurations = {
          justin = home-manager.lib.homeManagerConfiguration {
            # This is also not the recommended way of passing `nixpkgs`,
            # for reasons (similar to `system` above) that are out-of-scope of this example.
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [
              # Before you ask why this is the only module--
              # when there are clearly others in the file tree--
              # please see the rest of the example files.
              ./users/justin/profile.nix
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
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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

    hyprland.url = "github:hyprwm/Hyprland";
    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";
    hyprpicker.url = "github:hyprwm/hyprpicker";
    hyprpaper.url = "github:hyprwm/hyprpaper";

    # anyrun launcher
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
