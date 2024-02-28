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

      gestures = {
        workspace_swipe = true;
      };

      input = {
        kb_layout = "us";
        follow_mouse = 2;

	touchpad = {
          natural_scroll = true;
	  tap-to-click = true;
	  clickfinger_behavior = true;
	  scroll_factor = 0.4;
	};
      };

      general = {
        
      };

      bind = [
        # applications
        "$MOD, RETURN, exec, kitty"
	"CONTROL, Q, exec, kitty"
        "$MOD, B, exec, firefox"

	# window controls
	"$MOD, Q, killactive,"

        "CONTROL, M, exit,"
      ];

    };

    extraConfig = ''
      exec-once = kitty
    '';
  };
}
