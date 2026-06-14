{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkIf isWSL;

  sys = config.modules.system.boot;
in {
  imports = [
    # inputs.lanzaboote.nixosModules.lanzaboote
  ];

  config = mkIf (sys.secureBoot && !isWSL config) {
    environment.systemPackages = [
      # For debugging and troubleshooting Secure Boot.
      pkgs.sbctl
    ];

    boot = {
      loader = {
        systemd-boot.enable = lib.mkForce false;
        limine = {
          enable = true;
          # secureBoot.enable = true;
        };
      };
      # bootspec.enable = true;
      # lanzaboote = {
      #   enable = true;
      #   pkiBundle = "/var/lib/sbctl/";
      # };
    };
  };
}
