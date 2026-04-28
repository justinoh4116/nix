{
  osConfig,
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cfg = osConfig.modules.usrEnv.desktop.stasis;
in {
  imports = [inputs.stasis.homeModules.default];
  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.pulseaudio # required for idle inhibition based on media
      pkgs.daemonize
    ];
    services.stasis = {
      enable = true;
      extraConfig = ''
        @author "Dustin Pilgrim"
        @description "Stasis configuration file"

        # Global variable
        default_timeout 300  # 5 minutes

        default:
          pre_suspend_command "${config.programs.hyprlock.package}/bin/hyprlock"
          monitor_media true
          ignore_remote_media true
          enable_loginctl true

          respect_idle_inhibitors true

          # Laptop lid behavior
          lid_close_action "lock-screen"  # lock-screen | suspend | custom | ignore
          lid_open_action "wake"          # wake | custom | ignore

          # Debounce: default is 3s; can be customized if needed
          #debounce_seconds 4

          # Applications that prevent idle when active
          # inhibit_apps [
          #   "vlc"
          #   "Spotify"
          #   "mpv"
          #   r".*\.exe"
          #   r"steam_app_.*"
          #   r"firefox.*"
          # ]

          # Laptop-only AC actions
          ac:
            # Instant brightness adjustment
            custom-brightness-instant:
              timeout 0
              command "${pkgs.brightnessctl}/bin/brightnessctl set 100%"
            end

            dpms:
              timeout 60  # 1 minute
              command "${osConfig.programs.niri.package}/bin/niri msg action power-off-monitors"
            end

            lock_screen:
              timeout 120  # 2 minutes
              command "${config.programs.hyprlock.package}/bin/hyprlock"
            end

            # suspend:
            #   timeout 300  # 5 minutes
            #   command "systemctl suspend"
            # end
          end

          # Laptop-only battery actions
          battery:
            custom-brightness-instant:
              timeout 0
              command "${pkgs.brightnessctl}/bin/brightnessctl set 40%"
            end

            brightness:
              timeout 30  # 1 minute
              command "${pkgs.brightnessctl}/bin/brightnessctl -s set 20"
              resume-command "${pkgs.brightnessctl}/bin/brightnessctl -r"
            end

            dpms:
              timeout 60  # 30 seconds
              command "${osConfig.programs.niri.package}/bin/niri msg action power-off-monitors"
              resume-command "${osConfig.programs.niri.package}/bin/niri msg action power-on-monitors"
            end

            suspend:
              timeout 120  # 2 minutes
              command "systemctl suspend"
            end
          end
        end
      '';
    };
  };
}
