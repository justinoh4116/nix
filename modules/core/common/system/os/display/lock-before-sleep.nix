{
  lib,
  config,
  pkgs,
  ...
}: let
  env = config.modules.usrEnv;
in {
  config = lib.mkIf env.desktop.enable {
    systemd.services.lock-before-sleep = {
      description = "Lock active sessions before entering sleep";
      wantedBy = ["sleep.target"];
      before = ["sleep.target"];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.systemd}/bin/loginctl lock-sessions";
        ExecStartPost = "${pkgs.coreutils}/bin/sleep 1";
      };
    };
  };
}
