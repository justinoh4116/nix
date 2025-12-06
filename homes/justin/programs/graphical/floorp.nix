{
  lib,
  osConfig,
  pkgs,
  ...
}: let
  floorp = pkgs.floorp-bin.override {
    extraPrefsFiles = [
      (builtins.fetchurl {
        url = "https://raw.githubusercontent.com/MrOtherGuy/fx-autoconfig/master/program/config.js";
        sha256 = "1mx679fbc4d9x4bnqajqx5a95y1lfasvf90pbqkh9sm3ch945p40";
      })
    ];
  };
in {
  config = lib.mkIf (osConfig.modules.system.programs.default.browser == "floorp") {
    programs.floorp = {
      enable = true;
      package = floorp;
    };
  };
  # home.packages = with pkgs; [
  #   (floorp-bin-unwrapped.override {
  #     extraPrefsFiles = [
  #       (builtins.fetchurl {
  #         url = "https://raw.githubusercontent.com/MrOtherGuy/fx-autoconfig/master/program/config.js";
  #         sha256 = "1mx679fbc4d9x4bnqajqx5a95y1lfasvf90pbqkh9sm3ch945p40";
  #       })
  #     ];
  #   })
  # ];
}
