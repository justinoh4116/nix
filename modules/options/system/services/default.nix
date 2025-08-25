{lib, config, ...}: let
  inherit (lib.modules) mkService;
in {
  imports = [

  ];
  options.modules.system.services = {
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
