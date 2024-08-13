{
  self,
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  wallpaper = "~/Pictures/wallpapers/11-0-Big-Sur-Color-Night.jpg";
in {
  imports = [
    # inputs.hyprpaper.homeManagerModules.default
  ];

  home.file."${config.xdg.configHome}/hypr/extraConf" = {
    source = ./dots;
  };

  services.hyprpaper = {
    enable = true;
    package = inputs.hyprpaper.packages.${pkgs.system}.default;

    settings = {
      preload = ["${wallpaper}"];
      wallpaper = [", ${wallpaper}"];
    };
  };

  wayland.windowManager.hyprland = {
    plugins = [
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      inputs.hy3.packages.${pkgs.system}.hy3
      inputs.hyprfocus.packages.${pkgs.system}.hyprfocus
    ];

    settings = {
      "$MOD" = "SUPER";

      exec-once = [
        "wl-paste --watch cliphist store"
        "hyprctl setcursor macOS-Monterey-White 24"
        "hypridle"
        "${inputs.pyprland.packages.${pkgs.system}.pyprland}/bin/pypr "
        # "hyprctl hyprpaper wallpaper \",~/Pictures/wallpapers/11090Big-Sur-Color-Night.jpg\""
        # "ags -c ~/.config/ags/bar/config.js"
      ];

      monitor = [
        "eDP-1, preferred, 0x0, 1.175, bitdepth, 10"
        "DP-10, preferred, 1928x0, 1"
        "DP-9, preferred, 3848x0, 2"
        ",preferred,auto,1"
      ];

      gestures = {
        workspace_swipe = true;
        workspace_swipe_distance = 700;
        workspace_swipe_fingers = 4;
        workspace_swipe_cancel_ratio = 0.2;
        workspace_swipe_min_speed_to_force = 5;
        workspace_swipe_direction_lock = true;
        workspace_swipe_direction_lock_threshold = 10;
        workspace_swipe_create_new = true;
      };

      group = {
        groupbar = {
          font_size = 10;
          gradients = false;
          text_color = "rgb(255, 255, 255)";
        };

        # "col.border_active" = "rgba(${c.primary_container}88);";
        # "col.border_inactive" = "rgba(${c.on_primary_container}88)";
      };

      input = {
        accel_profile = "flat";
        kb_layout = "us";
        follow_mouse = 2;
        sensitivity = 0.5;

        touchpad = {
          disable_while_typing = true;
          natural_scroll = true;
          tap-to-click = true;
          clickfinger_behavior = true;
          scroll_factor = 0.1;
        };
      };

      general = {
        layout = "hy3";
        gaps_out = 10;
        gaps_in = 10;
        "col.active_border" = "rgba(88888888)";
        "col.inactive_border" = "rgba(00000088)";
      };

      cursor = {
        no_warps = true;
      };

      bind = let
        monocle = "plugin:hy3:no_gaps_when_only";
      in [
        # applications
        "$MOD, RETURN, exec, kitty"
        "$MOD, B, exec, chromium"
        "$MOD, N, exec, kitty yazi ~"
        "$MOD, SPACE, exec, anyrun"
        # "SHIFT$MOD, SPACE, exec, anyrun"

        # toggle monocle
        "$MOD, M, exec, hyprctl keyword ${monocle} $(($(hyprctl getoption ${monocle} -j | jaq -r '.int') ^ 1))"

        # cycle wallpaper
        "SHIFT$MOD, W, exec, pypr wall next"

        # window controls
        "$MOD, Q, killactive,"
        "$MOD, F, fullscreen"

        "$MOD, H, hy3:movefocus, l"
        "$MOD, J, hy3:movefocus, d"
        "$MOD, K, hy3:movefocus, u"
        "$MOD, L, hy3:movefocus, r"

        "CONTROL$MOD, H, hy3:movefocus, l, visible"
        "CONTROL$MOD, J, hy3:movefocus, d, visible"
        "CONTROL$MOD, K, hy3:movefocus, u, visible"
        "CONTROL$MOD, L, hy3:movefocus, r, visible"

        "SHIFT$MOD, H, hy3:movewindow, l, once"
        "SHIFT$MOD, J, hy3:movewindow, d, once"
        "SHIFT$MOD, K, hy3:movewindow, u, once"
        "SHIFT$MOD, L, hy3:movewindow, r, once"

        "CONTROLSHIFT$MOD, H, hy3:movewindow, l, once, visible"
        "CONTROLSHIFT$MOD, J, hy3:movewindow, d, once, visible"
        "CONTROLSHIFT$MOD, K, hy3:movewindow, u, once, visible"
        "CONTROLSHIFT$MOD, L, hy3:movewindow, r, once, visible"

        "SHIFT$MOD, SPACE, togglefloating"

        "$MOD, e, hy3:makegroup, h"
        "$MOD, w, hy3:makegroup, v"
        # "$MOD, z, hy3:makegroup, tab"
        "$MOD, r, hy3:changegroup, opposite"
        # "$MOD, t, hy3:changegroup, toggletab"

        # workspace controls

        "$MOD, 1, workspace, 1"
        "$MOD, 2, workspace, 2"
        "$MOD, 3, workspace, 3"
        "$MOD, 4, workspace, 4"
        "$MOD, 5, workspace, 5"
        "$MOD, 6, workspace, 6"
        "$MOD, 7, workspace, 7"
        "$MOD, 8, workspace, 8"
        "$MOD, 9, workspace, 9"
        "$MOD, 0, workspace, 10"

        "$MOD, F1, workspace, 11"
        "$MOD, F2, workspace, 12"
        "$MOD, F3, workspace, 13"
        "$MOD, F4, workspace, 14"
        "$MOD, F5, workspace, 15"
        "$MOD, F6, workspace, 16"
        "$MOD, F7, workspace, 17"
        "$MOD, F8, workspace, 18"
        "$MOD, F9, workspace, 19"
        "$MOD, F10, workspace, 20"
        "$MOD, F11, workspace, 21"
        "$MOD, F12, workspace, 22"

        "SHIFT$MOD, 1, movetoworkspace, 1"
        "SHIFT$MOD, 2, movetoworkspace, 2"
        "SHIFT$MOD, 3, movetoworkspace, 3"
        "SHIFT$MOD, 4, movetoworkspace, 4"
        "SHIFT$MOD, 5, movetoworkspace, 5"
        "SHIFT$MOD, 6, movetoworkspace, 6"
        "SHIFT$MOD, 7, movetoworkspace, 7"
        "SHIFT$MOD, 8, movetoworkspace, 8"
        "SHIFT$MOD, 9, movetoworkspace, 9"
        "SHIFT$MOD, 0, movetoworkspace, 10"

        "SHIFT$MOD, F1, movetoworkspace, 11"
        "SHIFT$MOD, F2, movetoworkspace, 12"
        "SHIFT$MOD, F3, movetoworkspace, 13"
        "SHIFT$MOD, F4, movetoworkspace, 14"
        "SHIFT$MOD, F5, movetoworkspace, 15"
        "SHIFT$MOD, F6, movetoworkspace, 16"
        "SHIFT$MOD, F7, movetoworkspace, 17"
        "SHIFT$MOD, F8, movetoworkspace, 18"
        "SHIFT$MOD, F9, movetoworkspace, 19"
        "SHIFT$MOD, F10, movetoworkspace, 20"
        "SHIFT$MOD, F11, movetoworkspace, 21"
        "SHIFT$MOD, F12, movetoworkspace, 22"

        "ALT$MOD, 1, focusworkspaceoncurrentmonitor, 1"
        "ALT$MOD, 2, focusworkspaceoncurrentmonitor, 2"
        "ALT$MOD, 3, focusworkspaceoncurrentmonitor, 3"
        "ALT$MOD, 4, focusworkspaceoncurrentmonitor, 4"
        "ALT$MOD, 5, focusworkspaceoncurrentmonitor, 5"
        "ALT$MOD, 6, focusworkspaceoncurrentmonitor, 6"
        "ALT$MOD, 7, focusworkspaceoncurrentmonitor, 7"
        "ALT$MOD, 8, focusworkspaceoncurrentmonitor, 8"
        "ALT$MOD, 9, focusworkspaceoncurrentmonitor, 9"
        "ALT$MOD, 0, focusworkspaceoncurrentmonitor, 10"

        "ALT$MOD, F1, focusworkspaceoncurrentmonitor, 11"
        "ALT$MOD, F2, focusworkspaceoncurrentmonitor, 12"
        "ALT$MOD, F3, focusworkspaceoncurrentmonitor, 13"
        "ALT$MOD, F4, focusworkspaceoncurrentmonitor, 14"
        "ALT$MOD, F5, focusworkspaceoncurrentmonitor, 15"
        "ALT$MOD, F6, focusworkspaceoncurrentmonitor, 16"
        "ALT$MOD, F7, focusworkspaceoncurrentmonitor, 17"
        "ALT$MOD, F8, focusworkspaceoncurrentmonitor, 18"
        "ALT$MOD, F9, focusworkspaceoncurrentmonitor, 19"
        "ALT$MOD, F10, focusworkspaceoncurrentmonitor, 20"
        "ALT$MOD, F11, focusworkspaceoncurrentmonitor, 21"
        "ALT$MOD, F12, focusworkspaceoncurrentmonitor, 22"

        "$MOD, Tab, workspace, e+1"
        "SHIFT$MOD, Tab, workspace, e-1"

        # other binds
        ", XF86MONBrightnessDown, exec, brightnessctl s 10-"
        ", XF86MONBrightnessUp, exec, brightnessctl s +10"

        ", XF86AudioLowerVolume, exec, pamixer -d 10"
        ", XF86AudioRaiseVolume, exec, pamixer -i 10"
        ", XF86AudioMute, exec, pamixer -t"

        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"

        ", Print, exec, grimblast --notify copysave area"
        "ALT, Print, exec, hyprpicker -a"

        # cliphist
        "$SUPER, V, exec, cliphist list | anyrun --plugins ${inputs.anyrun.packages.${pkgs.system}.stdin}/lib/libstdin.so --show-results-immediately true | cliphist decode | wl-copy"
      ];

      bindm = [
        "$MOD, mouse:272, movewindow"
        "$MOD, mouse:273, resizewindow"
        "SHIFT$MOD, mouse:272, resizewindow"
      ];

      # windowrulev2 = [
      # ];

      # layerrule = [
      #   "blur, ^(bar)"
      # ];

      misc = {
        force_default_wallpaper = 0;
        vrr = 1;
      };

      env = [
        "XCURSOR_THEME, macOS-Monterey-White"
        "XCURSOR_SIZE, 24"
        "QT_QPA_PLATFORMTHEME,qt5ct"
      ];

      animations = {
        enabled = true;
        bezier = [
          "bezier, 0.04, 0.8, 0.2, 1.08"
          "linear, 0, 0, 1, 1"
          "md3_standard, 0.2, 0, 0, 1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
          "md3_accel, 0.3, 0, 0.8, 0.15"
          "overshot, 0.05, 0.9, 0.1, 1.1"
          "crazyshot, 0.1, 1.5, 0.76, 0.92"
          "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
          "menu_decel, 0.1, 1, 0, 1"
          "menu_accel, 0.38, 0.04, 1, 0.07"
          "easeInOutCirc, 0.85, 0, 0.15, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutExpo, 0.16, 1, 0.3, 1"
          "softAcDecel, 0.26, 0.26, 0.15, 1"
          "md2, 0.4, 0, 0.2, 1 # use with .2s duration"
        ];
        animation = [
          # Animation curves

          # Animation configs
          "windows, 1, 3, md3_decel, popin 60%"
          "windowsIn, 1, 3, md3_decel, popin 60%"
          "windowsOut, 1, 3, md3_accel, popin 60%"
          "border, 1, 10, default"
          "fade, 1, 3, md3_decel"
          # animation = layers, 1, 2, md3_decel, slide
          "layersIn, 1, 3, menu_decel, slide"
          "layersOut, 1, 1.6, menu_accel"
          "fadeLayersIn, 1, 2, menu_decel"
          "fadeLayersOut, 1, 4.5, menu_accel"
          # "animation = workspaces, 1, 7, menu_decel, slide"
          # animation = workspaces, 1, 2.5, softAcDecel, slide
          "workspaces, 1, 7, menu_decel, slidefade 15%"
          # animation = specialWorkspace, 1, 3, md3_decel, slidefadevert 15%
          "specialWorkspace, 1, 3, md3_decel, slidevert"
          # "windows, 1, 2.5, bezier, slide"
          # "fade, 1, 1, default"
          # "workspaces, 1, 3, bezier, slide"
        ];
      };

      decoration = {
        rounding = 4;

        # dim_inactive = true;
        # dim_strength = .2;
        # dim_special = 0;

        # blur = {
        #   enabled = true;
        #   size = 16;
        #   passes = 5;
        # };
        blur = {
          enabled = true;
          brightness = 1.0;
          contrast = 1.0;
          noise = 0.01;

          vibrancy = 0.2;
          vibrancy_darkness = 0.5;

          passes = 4;
          size = 7;

          popups = true;
          popups_ignorealpha = 0.2;
        };
      };

      plugin = {
        hyprbars = {
          bar_height = 20;
          bar_precedence_over_border = true;

          # order is right-to-left
          hyprbars-button = [
            # close
            "rgb(ff0000), 15, , hyprctl dispatch killactive"
            # maximize
            "rgb(ffff00), 15, , hyprctl dispatch fullscreen 1"
          ];
        };
        hy3 = {
          no_gaps_when_only = 1;
          tabs = {
            height = 5;
            padding = 5;
            render_text = false;
            col.active = "0xffffff";
          };
        };
        hyprfocus = {
          enabled = true;
          focus_animation = "flash";
          animate_workspacechange = true;
        };
        hyprexpo = {
          columns = 3;
          gap_size = 5;
          bg_col = "rgb(000000)";
          workspace_method = "first 1";

          enable_gesture = true;
          gesture_fingers = 4;
          gesture_distance = 300;
          gesture_positive = false;
          gesture_negative = true;
        };
      };
    };

    extraConfig = ''
      xwayland {
        force_zero_scaling = true
      }
    '';
  };
}
