{
  self,
  inputs,
  lib,
  pkgs,
  ...
}: {
  networking.nat = {
    enable = true;
    internalInterfaces = ["ve-+"];
    externalInterface = "enp7s0";
    # Lazy IPv6 connectivity for the container
    enableIPv6 = true;
  };
  networking.networkmanager.unmanaged = ["interface-name:ve-*"];
}
