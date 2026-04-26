{
  inputs,
  pkgs,
  lib,
  osConfig,
  ...
}: let
  cfg = osConfig.modules.usrEnv.desktop.launchers.vicinae;
  desktop = osConfig.modules.usrEnv.desktop;
in {
  imports = [inputs.vicinae.homeManagerModules.default];

  config = lib.mkIf cfg.enable {
    services.vicinae = {
      enable = true;
      systemd.enable = true;

      settings = {
        close_on_focus_loss = true;
        theme = {
          light = {
            name = "vicinae-light";
            icon_theme = "default";
          };
          dark = {
            name = "vicinae-dark";
            icon_theme = "default";
          };
        };

        launcher_window = {
          opacity = 0.5;
        };

        providers = {
          "@Gelei/bluetooth-0" = {
            preferences = {
              connectionToggleable = true;
            };
          };
          "applications" = {
            preferences = {
              launchPrefix = "uwsm app -- ";
            };
          };
        };
      };

      extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
        # bluetooth
        nix
        wifi-commander
      ];
    };
  };
}
