{pkgs, ...}: {
  config.modules.usrEnv = {
    desktop = {
      wms = {
        hyprland.enable = true;
        river.enable = true;
        niri.enable = true;
      };
      wm = "niri";
    };
  };
}
