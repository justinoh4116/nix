{
  self,
  pkgs,
  inputs,
  lib,
  modulesPath,
  config,
  osConfig,
  ...
}: let
  cfg = osConfig.modules.usrEnv.desktop.launchers.anyrun;
  desktop = osConfig.modules.usrEnv.desktop;
in {
  imports = [inputs.anyrun.homeManagerModules.default];
  disabledModules = ["${modulesPath}/programs/anyrun.nix"];


  config = lib.mkIf (desktop.enable && cfg.enable) {
    programs.anyrun = {
      enable = true;
      package = inputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins;
      config = {
        plugins = [
          "stdin"
          "applications"
          "rink"
          "symbols"
          "nix-run"
          "niri-focus"
          # "${pkgs.anyrun}/lib/libstdin.so"
          # "${pkgs.anyrun}/lib/libapplications.so"
          # "${pkgs.anyrun}/lib/librink.so"
          # "${pkgs.anyrun}/lib/libsymbols.so"
          #inputs.anyrun.packages.${pkgs.system}.randr
        ];
        width = {fraction = 0.3;};
        height = {fraction = 0.2;};
        x = {fraction = 0.5;};
        y = {fraction = 0.3;};
        layer = "overlay";
        hidePluginInfo = true;
      };

      extraCss = builtins.readFile (./. + "/style-dark.css");

      # extraCss = ''
      #   $fontSize: 1.3rem;
      #   /* $fontFamily: Lexend; */
      #   $transparentColor: transparent;
      #   $rgbaColor: rgba(203, 166, 247, 0.7);
      #   $bgColor: rgba(30, 30, 46, 1);
      #   $borderColor: #28283d;
      #   $borderRadius: 16px;
      #   $paddingValue: 8px;
      #
      #   * {
      #   	transition: 200ms ease;
      #   	font-family: $fontFamily;
      #   	font-size: $fontSize;
      #   }
      #
      #   #window,
      #   #match,
      #   #entry,
      #   #plugin,
      #   #main {
      #   	background: $transparentColor;
      #   }
      #
      #   #match:selected {
      #   	background: $rgbaColor;
      #   }
      #
      #   #match {
      #   	padding: 3px;
      #   	border-radius: $borderRadius;
      #   }
      #
      #   #entry,
      #   #plugin:hover {
      #   	border-radius: $borderRadius;
      #   }
      #
      #   box#main {
      #   	background: $bgColor;
      #   	border: 1px solid $borderColor;
      #   	border-radius: $borderRadius;
      #   	padding: $paddingValue;
      #   }

      # '';
      # extraConfigFiles."style.css".source = dots/style.css;
    };

    };

}
