{
  keys,
  osConfig,
  ...
}: let
  cfg = osConfig.modules.system.programs.git;
in {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Justin Oh";
        email = "justinoh4116@gmail.com";
      };
    };

    signing = {
      key = cfg.signingKey;
      signByDefault = true;
      format = "ssh";
    };
  };
}
