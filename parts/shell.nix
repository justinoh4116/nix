{
  perSystem =
    {
      inputs',
      config,
      pkgs,
      ...
    }:
    {
      devShells.default = pkgs.mkShellNoCC {
        name = "nix config shell";
        meta.description = ''
          The default development shell for my NixOS configuration
        '';

        # Set up pre-commit hooks when user enters the shell.
        shellHook = ''
          ${config.pre-commit.installationScript}
        '';

        # Tell Direnv to shut up.
        DIRENV_LOG_FORMAT = "";

        # Receive packages from treefmt's configured devShell.
        inputsFrom = [ config.treefmt.build.devShell ];
        packages = [
          # Packages provided by flake inputs
          inputs'.agenix.packages.default # agenix CLI for secrets management
          pkgs.git
          pkgs.nodejs # building ags and configuring eslint_d will require nodejs
          config.agenix-rekey.package
        ];
      };
    };
}
