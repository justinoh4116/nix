{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption;
  inherit (lib.types) listOf port;
in {
  imports = [./tailscale.nix];

  options.modules.system.networking = {
    firewall.allowedTCPPorts = mkOption {
      type = listOf port;
      default = [];
      description = "TCP ports to allow through the firewall";
    };
  };

  config.networking.firewall.allowedTCPPorts = config.modules.system.networking.firewall.allowedTCPPorts;
}
