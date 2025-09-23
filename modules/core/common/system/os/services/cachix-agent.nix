{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.system.services.cachix-agent;
in {
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
