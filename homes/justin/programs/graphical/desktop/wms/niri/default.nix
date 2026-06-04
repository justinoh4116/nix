{
  osConfig,
  pkgs,
  lib,
  config,
  self,
  inputs,
  ...
}: let
  env = osConfig.modules.usrEnv;
  cfg = env.desktop.wms.niri;
  desktop = osConfig.modules.usrEnv.desktop;
  screenshotHelper = pkgs.writeShellApplication {
    name = "niri-screenshot";
    runtimeInputs = with pkgs; [
      coreutils
      grim
      jq
      niri
      satty
      slurp
      wl-clipboard
      libnotify
    ];
    text = ''
      mode="''${1:-area}"

      screenshots_dir="$HOME/safe/pictures/screenshots"
      mkdir -p "$screenshots_dir"
      output_file="$screenshots_dir/Screenshot from $(date '+%Y-%m-%d %H-%M-%S').png"

      run_satty() {
        satty \
          --filename - \
          --fullscreen \
          --output-filename "$output_file" \
          --copy-command wl-copy \
          --actions-on-enter save-to-clipboard,save-to-file,exit \
          --actions-on-right-click save-to-clipboard,save-to-file,exit \
          --actions-on-escape exit
      }

      case "$mode" in
        area)
          geometry="$(slurp)" || exit 0
          [[ -n "$geometry" ]] || exit 0
          grim -g "$geometry" -t ppm - | run_satty
          ;;
        output)
          output_name="$(niri msg --json focused-output | jq -r '.name // empty')"
          if [[ -z "$output_name" ]]; then
            notify-send "Screenshot failed" "No focused output found."
            exit 1
          fi

          grim -o "$output_name" -t ppm - | run_satty
          ;;
        window)
          window_json="$(niri msg --json focused-window)"
          output_json="$(niri msg --json focused-output)"

          if [[ "$window_json" == "null" ]]; then
            notify-send "Screenshot failed" "No focused window found."
            exit 1
          fi

          if [[ "$output_json" == "null" ]]; then
            notify-send "Screenshot failed" "No focused output found."
            exit 1
          fi

          geometry="$(
            jq -nr \
              --argjson window "$window_json" \
              --argjson output "$output_json" \
              '
                ($window.layout.tile_pos_in_workspace_view // error("focused window is not visible")) as $pos
                | ($window.layout.tile_size // error("focused window has no tile size")) as $size
                | ($output.logical // error("focused output is unavailable")) as $out
                | "\((($out.x + $pos[0]) | round)),\((($out.y + $pos[1]) | round)) \(($size[0] | round))x\(($size[1] | round))"
              '
          )" || {
            notify-send "Screenshot failed" "Could not resolve the focused window geometry."
            exit 1
          }

          grim -g "$geometry" -t ppm - | run_satty
          ;;
        *)
          printf 'usage: %s <area|output|window>\n' "$0" >&2
          exit 2
          ;;
      esac
    '';
  };
  ocrHelper = pkgs.writeShellApplication {
    name = "screen-area-ocr";
    runtimeInputs = with pkgs; [
      coreutils
      grim
      libnotify
      slurp
      tesseract
      wl-clipboard
    ];
    text = ''
      geometry="$(slurp)" || exit 0
      [[ -n "$geometry" ]] || exit 0

      image_file="$(mktemp --suffix=.png)"
      trap 'rm -f "$image_file"' EXIT

      grim -g "$geometry" "$image_file"
      text="$(tesseract "$image_file" stdout "$@" 2>/dev/null)"

      if [[ -z "$(printf '%s' "$text" | tr -d '[:space:]')" ]]; then
        notify-send "OCR" "No text recognized in the selected area."
        exit 1
      fi

      printf '%s' "$text" | wl-copy
      printf '%s\n' "$text"

      preview="$(printf '%s' "$text" | tr '\n' ' ' | cut -c1-160)"
      notify-send "OCR copied to clipboard" "$preview"
    '';
  };
  suspendIfLocked = pkgs.writeShellApplication {
    name = "suspend-if-locked";
    runtimeInputs = with pkgs; [
      procps
      systemd
    ];
    text = ''
      pidof hyprlock >/dev/null || exit 0
      systemctl suspend
    '';
  };
in {
  imports = [
  ];
  config = lib.mkIf (desktop.enable && cfg.enable) {
    home.packages = [
      screenshotHelper
      ocrHelper
      suspendIfLocked
      pkgs.libnotify
      pkgs.wlogout
      self.packages.${pkgs.stdenv.hostPlatform.system}.piri
      pkgs.python3
    ];
    home.file."${config.xdg.configHome}/niri" = {
      source = ./dots;
      recursive = true;
    };
    home.file."${config.xdg.configHome}/wlogout" = {
      source = ./wlogout;
      recursive = true;
    };
    programs.niri = {
      # enable = true;
      # package = inputs.niri-flake.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;
      config = null;
    };
  };
}
