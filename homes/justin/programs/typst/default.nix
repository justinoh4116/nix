{
  lib,
  pkgs,
  osConfig,
  ...
}: let
  env = osConfig.modules.usrEnv;
in {
  config = lib.mkIf env.programs.typst.enable {
    home.packages = with pkgs; [
      typst
      tinymist
      websocat
    ];
  };
}
