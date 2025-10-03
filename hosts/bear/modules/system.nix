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

    programs = {
      cli.enable = true;
      # gui.enable = true;
      dev.enable = true;

      fish.enable = true;

      default = {
        editor = "neovim";
      };
    };
  };
}
