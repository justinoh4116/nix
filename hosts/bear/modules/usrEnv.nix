{pkgs, ...}: {
  config.modules.usrEnv = {
    desktop = {
      wms = {
        hyprland.enable = true;
        river.enable = true;
      };
    };
    programs = {
      latex.enable = true;
    };
  };
}
