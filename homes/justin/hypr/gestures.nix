{
  inputs,
  pkgs,
  self,
  config,
  lib,
  ...
}: {
  home.packages = [
    inputs.gestures.packages.${pkgs.system}.gestures
  ];

  home.file."${config.xdg.configHome}/gestures/gestures.kdl" = {
    source = ./gestures.kdl;
  };

  # programs.ydotool.enable = true;

  # systemd.user.services = {
  #   ydotoold = {
  #     Unit = {
  #       Description = "An wayland auto-input utility";
  #       Documentation = ["man:ydotool(1)" "man:ydotoold(8)"];
  #     };
  #
  #     Service = {
  #       ExecStart = "/run/current-system/sw/bin/ydotoold --socket-path
  #                     $HOME/.ydotool_socket --socket-own=\"1000:100\"";
  #     };
  #
  #     Install = {
  #       WantedBy = ["default.target"];
  #     };
  #   };
  # };
}
