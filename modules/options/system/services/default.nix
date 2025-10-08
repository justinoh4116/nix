{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkService;
  inherit (lib) mkEnableOption;
in {
  imports = [
    ./syncthing.nix
    ./cachix-agent.nix
  ];
  options.modules.system.services = {
    bolt.enable = mkEnableOption "thunderbolt";
    actual.enable = mkEnableOption "actual finance manager";
    authelia.enable = mkEnableOption "authelia login manager";
    caddy.enable = mkEnableOption "caddy proxy service";
    changedetection-io.enable = mkEnableOption "website changedetection service";
    crowdsec.enable = mkEnableOption "crowdsec security";
    ddclient.enable = mkEnableOption "ddclient ddns";
    firefox-syncserver.enable = mkEnableOption "firefox-syncserver";
    immich.enable = mkEnableOption "immich photo/video server";
    nextcloud.enable = mkEnableOption "nextcloud cloud file storage";
    paperless.enable = mkEnableOption "paperless files";
    samba.enable = mkEnableOption "samba file sharing";
    vaultwarden.enable = mkEnableOption "vaultwarden password manager";
    wg-easy.enable = mkEnableOption "wireguard vpn and wg-easy web ui";
    # glance
    # immich
    # oink
    # nextcloud
    # paperless
    # vaultwarden
    # wg-easy
  };
}
