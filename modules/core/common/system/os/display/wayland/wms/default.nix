{
  lib,
  config,
  ...
}: {
  imports = lib.mkIf (!lib.isWSL config) [
    ./river
    ./hyprland
  ];
}
