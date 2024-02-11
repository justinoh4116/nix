{ config, pkgs, lib, ... }: {
  home.packages = [ pkgs.libnotify ];

  services.dunst = {
    enable = true;

    waylandDisplay = "wayland-0";

    settings = let

    in {
      global = {
        # position
	layer = "overlay";
	# monitor = 1;
	follow = "mouse";
	origin = "top-right";
	offset = "6x32";

	# limits
	notification-limit = 7;
	indicate_hidden = true;
	idle_threshold = "1m";
	sticky_history = 20;

	# appearance
	frame_wdith = 1;
	corner_radius = 10;
	width = "(250, 450)";
        height = "(200, 500)";
	gap_size = 6;

	#actions
	mouse_left_click = "do_action";
	mouse_right_click = "close_current";
	mouse_middle_click = "context";
	dmenu = "$lib.getExe confgi.programs.rofi.package} -dmenu -p dunst";
      };
    };
  };

}
