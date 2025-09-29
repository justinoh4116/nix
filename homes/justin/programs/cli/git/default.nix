{
  keys,
  osConfig,
  ...
}: let
  cfg = osConfig.modules.system.programs.git.signingKey;
in {
  programs.git = {
    enable = true;
    userName = "Justin Oh";
    userEmail = "justinoh4116@gmail.com";

    signing = {
      key = cfg.signingKey;
      signByDefault = true;
      format = "ssh";
    };
  };
}
