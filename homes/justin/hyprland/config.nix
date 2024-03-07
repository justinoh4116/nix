{
  self,
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  home.file."${config.xdg.configHome}/hypr/extraConf" = {
    source = ./dots;
  };

  wayland.windowManager.hyprland = {
    plugins = [
      inputs.hy3.packages.${pkgs.system}.hy3
      #inputs.hyprfocus.packages.${pkgs.system}.hyprfocus
    ];

    settings = {
      "$MOD" = "SUPER";

      monitor = [
        "eDP-1, preferred, 0x0, 1.333333"
      ];

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 4;
      };

      input = {
        accel_profile = "flat";
        kb_layout = "us";
        follow_mouse = 2;
        sensitivity = 0.3;

        touchpad = {
          disable_while_typing = true;
          natural_scroll = true;
          tap-to-click = true;
          clickfinger_behavior = true;
          scroll_factor = 0.4;
        };
      };

      general = {
        layout = "hy3";
        no_cursor_warps = "true";
      };

      bind = [
        # applications
        "$MOD, RETURN, exec, kitty"
        "$MOD, B, exec, firefox"
        "$MOD, SPACE, exec, anyrun"

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

        "$MOD, w, hy3:makegroup, h"
        "$MOD, e, hy3:makegroup, v"
        "$MOD, z, hy3:makegroup, tab"
        "$MOD, r, hy3:changegroup, opposite"
        "$MOD, t, hy3:changegroup, toggletab"

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

        "$MOD, Tab, workspace, e+1"
        "SHIFT$MOD, Tab, workspace, e-1"

        # other binds
        ", XF86MONBrightnessDown, exec, brightnessctl s 10-"
        ", XF86MONBrightnessUp, exec, brightnessctl s +10"

        ", Print, exec, ~/.config/hypr/scripts/screenshot"
      ];

      bindm = [
        "$MOD, mouse:272, movewindow"
        "$MOD, mouse:273, resizewindow"
        "SHIFT$MOD, mouse:272, resizewindow"
      ];

      windowrulev2 = [
        "float, class:^(anyrun)$"
      ];

      misc = {
        force_default_wallpaper = 0;
      };

      animations = {
        enabled = true;
        bezier = [
          "bezier, 0.04, 0.8, 0.2, 1.08"
        ];
        animation = [
          "windows, 1, 2.5, bezier, slide"
          "fade, 1, 1, default"
          "workspaces, 1, 3, bezier, slide"
        ];
      };
    };

    extraConfig = ''
      exec-once = hyprctl setcursor macOS-Monterey-White 24
      source = ./extraConf/plugins.conf
    '';
  };
}
