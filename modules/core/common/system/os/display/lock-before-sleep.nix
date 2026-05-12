{
  lib,
  config,
  pkgs,
  ...
}: let
  env = config.modules.usrEnv;
  hyprlockExe = lib.getExe config.programs.hyprlock.package;
in {
  config = lib.mkIf env.desktop.enable {
    systemd.services.lock-before-sleep = {
      description = "Lock active sessions before entering sleep";
      wantedBy = ["pre-sleep.service"];
      before = ["pre-sleep.service"];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${hyprlockExe}";
        # ExecStartPost = "${pkgs.coreutils}/bin/sleep 1";
      };
    };
  };
}
