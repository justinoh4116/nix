{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.walker.homeManagerModules.walker
  ];

  programs.walker = {
    enable = true;
    runAsService = true;

    # All options from the config.json can be used here.
    config = {
      placeholder = "Search";
      fullscreen = false;
      list = {
        height = 200;
      };
      modules = [
        {
          name = "applications";
          prefix = "";
        }
        {
          name = "runner";
          prefix = "";
        }
        {
          name = "ssh";
          prefix = "";
          switcher_exclusive = true;
        }
        {
          name = "finder";
          prefix = "";
          switcher_exclusive = true;
        }
        {
          name = "commands";
          prefix = "";
          switcher_exclusive = true;
        }
        {
          name = "websearch";
          prefix = "?";
        }
        {
          name = "switcher";
          prefix = "/";
        }
      ];
    };

    # If this is not set the default styling is used.
    # style = ''
    #         * {
    #   color: #2C2F50;
    #   font-family: "SFProText Nerd Font";
    #         }
    # '';
  };
}
