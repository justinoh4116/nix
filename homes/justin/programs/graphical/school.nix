{
  inputs,
  system,
  pkgs,
  ...
}: let
  pkgs-logisim-m16 = import inputs.nixpkgs-logisim-m16 {
    # inherit system;
    system = "${pkgs.stdenv.hostPlatform.system}";
    config.allowUnfree = true;
  };
in {
  config = {
    home.packages = [
      pkgs-logisim-m16.logisim-m16
    ];
  };
}
