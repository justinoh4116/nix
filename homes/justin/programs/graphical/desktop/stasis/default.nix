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
    services.stasis = {
      enable = true;
      extraConfig = ''
        @author "Dustin Pilgrim"
        @description "Stasis configuration file"

        # Global variable
        default_timeout 300  # 5 minutes

        default:
          pre_suspend_command "noctalia-shell ipc call lockScreen lock"
          monitor_media true
          ignore_remote_media true

          respect_idle_inhibitors true

          # Laptop lid behavior
          #lid_close_action "lock-screen"  # lock-screen | suspend | custom | ignore
          #lid_open_action "wake"          # wake | custom | ignore

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

          # Desktop-only idle actions (applies to all devices)
          # lock_screen:
          #   timeout 300  # 5 minutes
          #   command "loginctl lock-session"
          #   resume-command "notify-send 'Welcome Back $env.USER!'"
          #   lock-command "swaylock"
          # end

          dpms:
            timeout 60  # 1 minute
            command "niri msg action power-off-monitors"
            resume-command "niri msg action power-on-monitors"
          end

          suspend:
            timeout 300  # 5 min
            command "systemctl suspend"
            # resume-command None
          end

          # Laptop-only AC actions
          ac:
            # Instant brightness adjustment
            custom-brightness-instant:
              timeout 0
              command "brightnessctl set 100%"
            end

            brightness:
              timeout 120  # 2 minutes
              command "brightnessctl set 30%"
            end

            dpms:
              timeout 60  # 1 minute
              command "niri msg action power-off-monitors"
            end

            # lock_screen:
            #   timeout 120  # 2 minutes
            #   command "swaylock"
            # end

            # suspend:
            #   timeout 300  # 5 minutes
            #   command "systemctl suspend"
            # end
          end

          # Laptop-only battery actions
          battery:
            custom-brightness-instant:
              timeout 0
              command "brightnessctl set 40%"
            end

            brightness:
              timeout 60  # 1 minute
              command "brightnessctl set 20%"
            end

            dpms:
              timeout 30  # 30 seconds
              command "niri msg action power-off-monitors"
              resume-command "niri msg action power-on-monitors"
            end

            # lock_screen:
            #   timeout 120  # 2 minutes
            #   command "swaylock"
            #   resume-command "notify-send 'Welcome back $env.USER!'"
            # end

            suspend:
              timeout 120  # 2 minutes
              command "systemctl suspend"
            end
          end
        end
      '';
    };
    # home = {
    #   packages = [
    #     pkgs.stasis
    #   ];
    #   file."${config.xdg.configHome}/stasis/stasis.rune" = {
    #     source = ./stasis.rune;
    #   };
    # };
    # systemd.user.services.stasis = {
    #   Unit = {
    #     Description = "stasis idle manager";
    #     PartOf = [
    #       "graphical-session.target"
    #     ];
    #     After = "graphical-session.target";
    #     ConditionEnvironment = "WAYLAND_DISPLAY";
    #   };
    #   Service = {
    #     Type = "simple";
    #     ExecStart = "${pkgs.stasis}/bin/stasis";
    #     Restart = "on-failure";
    #   };
    #   Install.WantedBy = ["graphical-session.target"];
    # };
  };
}
