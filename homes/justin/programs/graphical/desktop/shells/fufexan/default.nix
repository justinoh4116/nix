{
  pkgs,
  inputs,
  lib,
  osConfig,
  ...
}: let
  quickshell = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
  quickshellDnd = pkgs.writeShellApplication {
    name = "quickshell-dnd";
    runtimeInputs = with pkgs; [coreutils];
    text = ''
      set -euo pipefail

      state_dir="''${XDG_STATE_HOME:-$HOME/.local/state}/quickshell"
      state_file="$state_dir/dnd"

      mkdir -p "$state_dir"

      normalize() {
        case "$(printf '%s' "''${1:-}" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')" in
          1|true|on|enabled)
            printf 'on\n'
            ;;
          ""|0|false|off|disabled)
            printf 'off\n'
            ;;
          *)
            printf 'invalid state: %s\n' "''${1:-}" >&2
            return 1
            ;;
        esac
      }

      write_state() {
        local normalized
        normalized="$(normalize "$1")"

        if [ "$normalized" = "on" ]; then
          printf '%s\n' true > "$state_file"
        else
          printf '%s\n' false > "$state_file"
        fi

        printf '%s\n' "$normalized"
      }

      read_state() {
        if [ -f "$state_file" ]; then
          normalize "$(cat "$state_file")"
        else
          write_state off >/dev/null
          printf 'off\n'
        fi
      }

      case "''${1:-toggle}" in
        toggle)
          if [ "$(read_state)" = "on" ]; then
            write_state off
          else
            write_state on
          fi
          ;;
        on|enable|enabled|true|1)
          write_state on
          ;;
        off|disable|disabled|false|0)
          write_state off
          ;;
        status)
          read_state
          ;;
        *)
          printf 'usage: quickshell-dnd [toggle|on|off|status]\n' >&2
          exit 2
          ;;
      esac
    '';
  };

  dependencies = with pkgs; [
    bash
    coreutils
    gawk
    lsof
    osConfig.programs.niri.package
    ripgrep
    procps
    quickshellDnd
    util-linux
  ];

  QML2_IMPORT_PATH = lib.concatStringsSep ":" [
    "${quickshell}/lib/qt-6/qml"
    "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml"
    "${pkgs.kdePackages.kirigami.unwrapped}/lib/qt-6/qml"
  ];
  cfg = osConfig.modules.usrEnv.desktop.shells.fufexan;
in {
  config = lib.mkIf cfg.enable {
    home.packages = [
      quickshell
      quickshellDnd
    ];

    home.sessionVariables.QML2_IMPORT_PATH = QML2_IMPORT_PATH;

    systemd.user.services.quickshell = {
      Unit = {
        Description = "Quickshell";
        PartOf = [
          "tray.target"
          "graphical-session.target"
        ];
        After = "graphical-session.target";
      };
      Service = {
        Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies} QML2_IMPORT_PATH=${QML2_IMPORT_PATH} QSG_RHI_BACKEND=vulkan";
        ExecStart = lib.getExe quickshell;
        Restart = "on-failure";
      };
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
