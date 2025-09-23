{
  config,
  lib,
  ...
}: let
  inherit (config.services) tailscale;

  sys = config.modules.system;
  cfg = sys.networking.tailscale;
in {
  imports = [./autoconnect.nix];

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [tailscale.package];

    networking.firewall = {
      trustedInterfaces = ["${tailscale.interfaceName}"];
      checkReversePath = "loose";
    };

    boot.kernel.sysctl = {
      # Enable IP forwarding
      # required for Wireguard & Tailscale/Headscale subnet feature
      # Technically, not all hosts do need to be able to IP forward but this could potentially
      # come in handy when I need to turn a host into an exit node.
      # See:
      #  <https://tailscale.com/kb/1019/subnets/?tab=linux#step-1-install-the-tailscale-client>
      "net.ipv4.ip_forward" = true;
      "net.ipv6.conf.all.forwarding" = true;
    };

    users = {
      groups.tailscaled = {};
      users.tailscaled = {
        group = "tailscaled";
        isSystemUser = true;
      };
    };

    # Enable Tailscale, the inter-machine VPN service
    # with our Headscale coordination server.
    services.tailscale = {
      enable = true;
      permitCertUid = "root";
      useRoutingFeatures = lib.mkDefault "both";
      # TODO: these flags still need to be specified with `tailscale up`
      # for some reason
      extraUpFlags = cfg.flags.final;
    };

    systemd = {
      # Ignore the default Tailscale interface for network.wait-online
      # this should generally mean faster boot, and the interface will
      # be "activated" once the auto-connect service is triggered.
      network.wait-online.ignoredInterfaces = ["${tailscale.interfaceName}"];

      # Wait until network-online and systemd-resolved are up
      # before starting tailscaled.
      services.tailscaled = {
        after = ["network-online.target" "systemd-resolved.service"];
        wants = ["network-online.target" "systemd-resolved.service"];
      };
    };
  };
}
