{
  imports = [
    ./authelia
    ./caddy

    ./actual.nix
    ./changedetection-io.nix
    ./crowdsec.nix
    ./immich.nix
    ./paperless.nix
    ./samba.nix
    ./vaultwarden.nix
    ./wg-easy.nix
  ];
}
