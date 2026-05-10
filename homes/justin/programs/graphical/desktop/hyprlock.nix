{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: let
  currentWallpaper = "${config.home.homeDirectory}/.current_wallpaper";
in {
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        # disable_loading_bar = true;
        immediate_render = true;
        hide_cursor = false;
        # no_fade_in = true;
      };

      auth = {
        fingerprint = {
          enabled = true;
        };
      };

      animation = [
        "inputFieldDots, 1, 2, linear"
        "fadeIn, 0"
      ];

      background = [
        {
          monitor = "";
          path = currentWallpaper;
        }
      ];

      input-field = [
        {
          monitor = "";

          size = "300, 50";
          valign = "bottom";
          position = "0%, 10%";

          outline_thickness = 1;

          font_family = "SF Pro";
          font_color = "rgb(ffffff)";
          outer_color = "rgba(180, 180, 180, 0.5)";
          inner_color = "rgba(200, 200, 200, 0.1)";
          check_color = "rgba(247, 193, 19, 0.5)";
          fail_color = "rgba(255, 106, 134, 0.5)";

          fade_on_empty = false;
          placeholder_text = "Enter Password";

          dots_spacing = 0.2;
          dots_center = true;
          # dots_fade_time = 100;

          shadow_color = "rgba(0, 0, 0, 0.1)";
          shadow_size = 7;
          shadow_passes = 2;
        }
      ];

      label = [
        {
          monitor = "";
          text = "cmd[update:1000] sh -c 'printf \"%s\\n%s\" \"$(date +\"%H\")\" \"$(date +\"%M\")\"'";
          font_family = "SF Pro";
          font_size = 150;
          color = "rgb(ffffff)";

          position = "0%, 28%";

          valign = "center";
          halign = "center";

          shadow_color = "rgba(0, 0, 0, 0.1)";
          shadow_size = 20;
          shadow_passes = 2;
          shadow_boost = 0.3;
        }
        {
          monitor = "";
          font_family = "SF Pro";
          text = "cmd[update:3600000] date +'%a %b %d'";
          font_size = 20;
          color = "rgb(ffffff)";

          position = "0%, 46%";

          valign = "center";
          halign = "center";

          shadow_color = "rgba(0, 0, 0, 0.1)";
          shadow_size = 20;
          shadow_passes = 2;
          shadow_boost = 0.3;
        }
      ];
    };
  };

  systemd.user.targets.lock = {
    Unit = {
      Description = "Lock session target";
    };
  };

  systemd.user.services.hyprlock = {
    Unit = {
      Description = "Hyprlock";
      # PartOf = ["graphical-session.target"];
      # After = ["graphical-session.target"];
    };

    Service = {
      ExecStart = lib.getExe config.programs.hyprlock.package;
    };

    Install.WantedBy = ["lock.target"];
  };
}
