{
  lib,
  config,
  flake,
  inputs,
  pkgs,
  ...
}: {
  users = {
    mutableUsers = false;
    users.root.initialHashedPassword = "$6$ADrvP50Wl7F3OFFO$WFPc38yKX4RZaUYdk2Cc2qOcjFYX69YVvAndY434OlXp4pkKd8aZRkhMm0viWtCcyx/ZmddYXBioAQSSKXSP80";

    users.justin = {
      initialHashedPassword = "$6$ADrvP50Wl7F3OFFO$WFPc38yKX4RZaUYdk2Cc2qOcjFYX69YVvAndY434OlXp4pkKd8aZRkhMm0viWtCcyx/ZmddYXBioAQSSKXSP80";
      isNormalUser = true;
      extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [
        tree
      ];
    };
  };
}
