{
  self,
  inputs,
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.misc.cachix;
in {
  options.misc.cachix = {
    enable = lib.mkEnableOption "cachix";
    credentialsFile = lib.mkOption {
      type = lib.types.path;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cachix
    ];

    services.cachix-agent = {
      enable = true;
      credentialsFile = cfg.credentialsFile;
    };
  };
}
