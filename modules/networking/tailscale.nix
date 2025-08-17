{
  self,
  inputs,
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.networking.tailscale;
in {
  options.modules.networking.tailscale = {
    enable = lib.mkEnableOption "tailscale";
    openFirewall = lib.mkEnableOption "opening firewall ports for tailscale";
    authKeyFile = lib.mkOption {
      type = lib.types.path;
    };
    extraUpFlags = lib.mkOption {
      type = lib.types.lines;
      example = ''
        --advertise-exit-node
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      openFirewall = cfg.openFirewall;
      authKeyFile = cfg.authKeyFile;
      extraUpFlags = [
        # "--advertise-exit-node"
        #   "--login-server=https://your-instance" # if you use a non-default tailscale coordinator
        #   "--accept-dns=false" # if its' a server you prolly dont need magicdns
      ];
    };
  };
}
