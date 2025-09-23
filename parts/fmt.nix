{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];
  perSystem = {
    inputs',
    config,
    pkgs,
    lib,
    ...
  }: {
    # Provide a formatter package for `nix fmt`. Setting this
    # to `config.treefmt.build.wrapper` will use the treefmt
    # package wrapped with my desired configuration.
    formatter = pkgs.alejandra;
  };
}
