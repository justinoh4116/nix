{
  osConfig,
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = osConfig.modules.usrEnv.desktop.stasis;
in {
  config = lib.mkIf cfg.enable {
    home = {
      packages = [
        pkgs.stasis
      ];
      file."${config.xdg.configHome}/stasis/stasis.rune" = {
        source = ./stasis.rune;
      };
    };
    systemd.user.services.stasis = {
      Unit = {
        Description = "stasis idle manager";
        PartOf = [
          "graphical-session.target"
        ];
        After = "graphical-session.target";
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.stasis}/bin/stasis";
        Restart = "on-failure";
      };
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
