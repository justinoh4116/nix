{
  inputs,
  lib,
  pkgs,
  osConfig,
  ...
}: {
  config = {
    home.packages = with pkgs; [
      inputs.t3code.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
