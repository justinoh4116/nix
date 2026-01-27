{
  pkgs,
  config,
  ...
}: {
  config.modules.system = {
    mainUser = "justin";

    boot = {
      loader = "none";
    };

    video.enable = false;



    programs = {
      cli.enable = true;
      gui.enable = false;
      dev.enable = true;

      fish.enable = true;

      default = {
        editor = "neovim";
      };
    };
  };
}
