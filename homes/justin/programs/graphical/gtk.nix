{
  pkgs,
  config,
  inputs,
  ...
}: {
  gtk = {
    enable = true;

    font = {
      name = "SFPro Text Nerd Font";
      package = inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd;
      size = 10;
    };

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    gtk4.theme = null;

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };

    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
  };
}
