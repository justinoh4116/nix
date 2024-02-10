{
  description = "flakey";
  inputs = {
    # There are many ways to reference flake inputs.
    # The most widely used is `github:owner/name/reference`,
    # which represents the GitHub repository URL + branch/commit-id/tag.

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      "nixos" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [

          # Import the configuration.nix here, so that the
          # old configuration file can still take effect.
          # Note: configuration.nix itself is also a Nixpkgs Module,
          /etc/nixos/configuration.nix

	  home-manager.nixosModules.home-manager {
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;

	    home-manager.users.justin = import ./home.nix;
	  }
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
            ./home.nix
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
}
