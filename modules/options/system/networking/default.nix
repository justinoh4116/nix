{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  imports = [./tailscale.nix];

  options.modules.system.networking = {
  };
}
