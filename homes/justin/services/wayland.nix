{
  inputs,
  osConfig,
  lib,
  ...
}: let
  env = osConfig.modules.usrEnv;
in {
  config = {
    services = {
      awww.enable = true;
    };
  };
}
