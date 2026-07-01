{
  lib,
  pkgs,
  config,
  ...
}: {
  config = {
    programs.npm = {
      enable = true;
      settings = {
        color = true;
        include = [
          "dev"
          "prod"
        ];
        init-license = "MIT";
        prefix = "\${HOME}/safe/npm";
      };
    };
  };
}
