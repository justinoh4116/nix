{
  inputs,
  self,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./glance.nix
    ./syncthing.nix
    ./authelia.nix
    ./crowdsec.nix
    # ./watchtower.nix
    ./oink.nix
    ./nextcloud.nix
    ./zfs.nix
    ./samba.nix
    ./changedetection-io.nix
    ./paperless.nix
    ./cachix.nix
    ./misc.nix
    ./factorio-server.nix
    ./github-runner.nix
    ./vaultwarden.nix
    ./caddy
    ./network.nix
    ./configuration.nix
    ./cli.nix
    ./hardware-configuration.nix
    ./tailscale.nix
    ./immich.nix
  ];
}
