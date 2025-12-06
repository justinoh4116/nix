{lib, ...}: let
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) str enum bool package int;
in {
  imports = [
    ./syncthing.nix
  ];

  options.modules.usrEnv.services = {
    nextcloud-client.enable = mkEnableOption "graphical nextcloud client service";
  };
}
