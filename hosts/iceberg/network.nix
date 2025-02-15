{
  self,
  inputs,
  lib,
  pkgs,
  ...
}: {
  networking = {
    nat = {
      enable = true;
      internalInterfaces = ["ve-+" "vb-+"];
      externalInterface = "enp7s0";
      # Lazy IPv6 connectivity for the container
      enableIPv6 = true;
    };
    bridges = {
      br0 = {
        interfaces = ["enp7s0"];
      };
    };
    useDHCP = false;
    interfaces."br0".useDHCP = true;

    interfaces."br0".ipv4.addresses = [
      {
        address = "192.168.100.3";
        prefixLength = 24;
      }
    ];
    defaultGateway = "192.168.0.1";
    nameservers = ["192.168.100.1" "1.1.1.1"];
  };
  networking.networkmanager.unmanaged = ["interface-name:ve-*"];
}
