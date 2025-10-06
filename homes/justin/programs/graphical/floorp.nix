{
  lib,
  osConfig,
  pkgs,
  ...
}: {
  # programs.floorp.enable = true;
  home.packages = with pkgs; [
    (floorp-bin.override {
      extraPrefsFiles = [
        (builtins.fetchurl {
          url = "https://raw.githubusercontent.com/MrOtherGuy/fx-autoconfig/master/program/config.js";
          sha256 = "1mx679fbc4d9x4bnqajqx5a95y1lfasvf90pbqkh9sm3ch945p40";
        })
      ];
    })
  ];
}
