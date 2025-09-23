{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./network-manager.nix
    ./ssh.nix
    ./tailscale
  ];

  networking = {
    # snippet from notashelf/nyx
    # generate a unique hostname by hashing the hostname
    # with md5 and taking the first 8 characters of the hash
    # this is especially helpful while using zfs but still
    # ensures that there will be a unique hostId even when
    # we are not using zfs
    hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);

    # global dhcp has been deprecated upstream
    # use the new networkd service instead of the legacy
    # "script-based" network setups. Host may contain individual
    # dhcp interfaces or systemd-networkd configurations in host
    # specific directories
    useDHCP = lib.mkForce false;
    useNetworkd = lib.mkForce true;
  };
}
