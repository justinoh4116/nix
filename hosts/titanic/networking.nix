{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/networking/tailscale.nix
  ];

  age.secrets.tailscale-auth.file = ../../secrets/tailscale-auth.age;

  # modules.networking.tailscale = {
  #   enable = true;
  #   authKeyFile = config.age.secrets.tailscale-auth.path;
  # };

  networking = {
    networkmanager.enable = true; # Easiest to use and most distros use this by default.
    nftables.enable = false;
    firewall = {
      package = pkgs.iptables-legacy;
    };
    nat = {
      enable = true;
      internalInterfaces = ["ve-+" "vb-+" "br0"];
      externalInterface = "enp3s0";
      # Lazy IPv6 connectivity for the container
      enableIPv6 = true;
    };
    bridges = {
      br0 = {
        # interfaces = ["enp3s0"];
        interfaces = [];
      };
    };
    #useDHCP = false;
    #interfaces."br0".useDHCP = true;

    # interfaces."br0".ipv4.addresses = [
    #   {
    #     address = "192.168.100.3";
    #     prefixLength = 24;
    #   }
    # ];
    # defaultGateway = "192.168.100.1";
    # nameservers = ["192.168.100.1" "1.1.1.1"];
  };
  networking.networkmanager.unmanaged = ["interface-name:ve-*" "interface-name:vb-*"];
}
