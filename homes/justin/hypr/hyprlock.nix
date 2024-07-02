{
  self,
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    # inputs.hyprpaper.homeManagerModules.default
  ];

  programs.hyprlock = {
    enable = true;

    settings = {
    };
  };

  services.hypridle = {
    enable = true;
    package = inputs.hypridle.packages.${pkgs.system}.hypridle;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
    };
  };

  # home.file."${config.xdg.configHome}/hypr/hypridle.conf" = {
  #   source = ./hypridle.conf;
  # };
}
