{
  config,
  lib,
  ...
}: let
  cfg = config.modules.system.services.rustdesk;
  env = config.modules.usrEnv;
in {
  config = lib.mkIf (cfg.enable && env.desktop.enable) {
    services.rustdesk-server = {
      enable = true;
      openFirewall = true;
      signal.enable = false;
      relay.enable = false;
    };
  };
}
