{
  self,
  inputs,
  pkgs,
  libg,
  ...
}:
{
  wayland.windowManager.hyprland = {
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
        no_cursor_warps = "true";
        
      };

      bind = [
        # applications
        "$MOD, RETURN, exec, kitty"
        "$MOD, B, exec, firefox"
        "$MOD, SPACE, exec, anyrun"

	    # window controls
	    "$MOD, Q, killactive,"

        "$MOD, H, movefocus, l"
        "$MOD, J, movefocus, d"
        "$MOD, K, movefocus, u"
        "$MOD, L, movefocus, r"

        "SHIFT$MOD, H, movewindow, l"
        "SHIFT$MOD, J, movewindow, d"
        "SHIFT$MOD, K, movewindow, u"
        "SHIFT$MOD, L, movewindow, r"

        "SHIFT$MOD, SPACE, togglefloating"

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
    '';
  };
}