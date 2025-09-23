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
    # actual
    # authelia
    # changedetection-io
    # factorio-server
    # glance
    # immich
    # oink
    # nextcloud
    # paperless
    # vaultwarden
    # wg-easy
  };
}
