{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  cfg = osConfig.modules.usrEnv.desktop.hypridle;
  waylandTarget = config.wayland.systemd.target;

  brightnessctlExe = "${pkgs.brightnessctl}/bin/brightnessctl";
  hyprlockExe = lib.getExe config.programs.hyprlock.package;
  niriExe = "${osConfig.programs.niri.package}/bin/niri";
  pidofExe = "${pkgs.procps}/bin/pidof";
  systemctlExe = "${pkgs.systemd}/bin/systemctl";

  lockCmd = "${pidofExe} hyprlock || ${hyprlockExe}";
  monitorOffCmd = "${niriExe} msg action power-off-monitors";
  monitorOnCmd = "${niriExe} msg action power-on-monitors";

  commonSettings = {
    general = {
      lock_cmd = lockCmd;
      before_sleep_cmd = lockCmd;
      after_sleep_cmd = monitorOnCmd;
      ignore_dbus_inhibit = false;
      ignore_systemd_inhibit = false;
      ignore_wayland_inhibit = false;
      inhibit_sleep = 3;
    };
  };

  acSettings =
    commonSettings
    // {
      listener = [
        {
          timeout = 120;
          "on-timeout" = monitorOffCmd;
        }
        {
          timeout = 240;
          "on-timeout" = lockCmd;
        }
      ];
    };

  batterySettings =
    commonSettings
    // {
      listener = [
        {
          timeout = 60;
          "on-timeout" = "${brightnessctlExe} -s set 20";
          "on-resume" = "${brightnessctlExe} -r";
        }
        {
          timeout = 120;
          "on-timeout" = monitorOffCmd;
          "on-resume" = monitorOnCmd;
        }
        {
          timeout = 180;
          "on-timeout" = "${systemctlExe} suspend";
        }
      ];
    };

  hyprConf = settings:
    lib.hm.generators.toHyprconf {
      attrs = settings;
      importantPrefixes = ["$"];
    };

  hypridleLauncher = pkgs.writeShellApplication {
    name = "hypridle-launcher";
    runtimeInputs = with pkgs; [
      coreutils
      hypridle
    ];
    text = ''
      config="${config.xdg.configHome}/hypr/hypridle.ac.conf"

      for status_file in /sys/class/power_supply/BAT*/status; do
        if [[ -f "$status_file" ]] && [[ "$(cat "$status_file")" == "Discharging" ]]; then
          config="${config.xdg.configHome}/hypr/hypridle.battery.conf"
          break
        fi
      done

      exec hypridle -c "$config"
    '';
  };

  hypridlePowerMonitor = pkgs.writeShellApplication {
    name = "hypridle-power-monitor";
    runtimeInputs = with pkgs; [
      brightnessctl
      coreutils
      inotify-tools
      systemd
    ];
    text = ''
      status_file=
      for candidate in /sys/class/power_supply/BAT*/status; do
        if [[ -f "$candidate" ]]; then
          status_file="$candidate"
          break
        fi
      done

      if [[ -z "$status_file" ]]; then
        exit 0
      fi

      apply_profile() {
        local profile="$1"

        case "$profile" in
          ac)
            brightnessctl set 100% >/dev/null 2>&1 || true
            ;;
          battery)
            brightnessctl set 40% >/dev/null 2>&1 || true
            ;;
        esac

        systemctl --user restart hypridle.service
      }

      current_profile=

      while true; do
        if [[ "$(cat "$status_file")" == "Discharging" ]]; then
          next_profile=battery
        else
          next_profile=ac
        fi

        if [[ "$next_profile" != "$current_profile" ]]; then
          apply_profile "$next_profile"
          current_profile="$next_profile"
        fi

        inotifywait -qq "$status_file"
      done
    '';
  };

  hypridleLidMonitor = pkgs.writeShellApplication {
    name = "hypridle-lid-monitor";
    runtimeInputs = with pkgs; [
      acpi
      gnugrep
      procps
      systemd
    ];
    text = ''
      acpi_listen | while IFS= read -r event; do
        if printf '%s\n' "$event" | grep -qE 'button/lid.*close'; then
          ${lockCmd}
        fi
      done
    '';
  };
in {
  config = lib.mkIf cfg.enable {
    xdg.configFile."hypr/hypridle.ac.conf".text = hyprConf acSettings;
    xdg.configFile."hypr/hypridle.battery.conf".text = hyprConf batterySettings;

    systemd.user.services.hypridle = {
      Install.WantedBy = [waylandTarget];

      Unit = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Description = "hypridle";
        After = [waylandTarget];
        PartOf = [waylandTarget];
        X-Restart-Triggers = [
          config.xdg.configFile."hypr/hypridle.ac.conf".source
          config.xdg.configFile."hypr/hypridle.battery.conf".source
        ];
      };

      Service = {
        ExecStart = lib.getExe hypridleLauncher;
        Restart = "always";
        RestartSec = "10";
      };
    };

    systemd.user.services.hypridle-power-monitor = {
      Install.WantedBy = [waylandTarget];

      Unit = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Description = "Switch hypridle profiles on power state changes";
        After = [
          "hypridle.service"
          waylandTarget
        ];
        PartOf = [waylandTarget];
      };

      Service = {
        ExecStart = lib.getExe hypridlePowerMonitor;
        Restart = "on-failure";
        RestartSec = "5";
      };
    };

    systemd.user.services.hypridle-lid-monitor = {
      Install.WantedBy = [waylandTarget];

      Unit = {
        Description = "Lock the session when the lid closes";
        After = [waylandTarget];
        PartOf = [waylandTarget];
      };

      Service = {
        ExecStart = lib.getExe hypridleLidMonitor;
        Restart = "always";
        RestartSec = "5";
      };
    };

    systemd.user.services.sway-audio-idle-inhibit = {
      Install.WantedBy = [waylandTarget];

      Unit = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Description = "Inhibit hypridle while audio is active";
        After = [waylandTarget];
        PartOf = [waylandTarget];
      };

      Service = {
        ExecStart = lib.getExe pkgs.sway-audio-idle-inhibit;
        Restart = "always";
        RestartSec = "5";
      };
    };
  };
}
