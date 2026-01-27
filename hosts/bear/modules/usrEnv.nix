{pkgs, ...}: {
  config.modules.usrEnv = {
    desktop = {
      wms = {
        hyprland.enable = false;
        river.enable = false;
      };
    };
    programs = {
      latex.enable = true;
    };
  };
}
