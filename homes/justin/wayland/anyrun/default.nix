{
  self,
  pkgs,
  inputs,
  lib,
  config,
  ...
}: {
  # imports = [inputs.anyrun.homeManagerModules.default];

  programs.anyrun = {
    enable = true;
    config = {
      plugins = [
        inputs.anyrun.packages.${pkgs.system}.stdin
        inputs.anyrun.packages.${pkgs.system}.applications
        inputs.anyrun.packages.${pkgs.system}.rink
        inputs.anyrun.packages.${pkgs.system}.symbols
        #inputs.anyrun.packages.${pkgs.system}.randr
      ];
      width = {fraction = 0.3;};
      height = {fraction = 0.2;};
      x = {fraction = 0.5;};
      y = {fraction = 0.3;};
      layer = "overlay";
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
}
