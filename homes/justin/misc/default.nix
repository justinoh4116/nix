{
  self,
  pkgs,
  inputs,
  config,
  opts,
  ...
}: {
  imports = [
    ./xdg.nix
    ./gammastep.nix
    ./dconf.nix
    ./age.nix
  ];

  config = {
    home.file.".config/nixpkgs/config.nix".source = ./nixpkgsconfig.nix;
    home.file."school".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/safe/nextcloud/school";
    home.file."documents".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/safe/nextcloud/documents";
    home.file.".local/bin/link-configs" = {
      source = ./bin/link-configs.nu;
      executable = true;
    };
    home.file.".local/bin/ripdrag-sticky" = {
      source = ./bin/ripdrag-sticky.nu;
      executable = true;
    };
    home.file.".local/bin/tt" = {
      source = ./bin/timewarrior-selector.nu;
      executable = true;
    };
    home.file.".local/bin/tmux-sessionizer" = {
      source = ./bin/tmux-sessionizer.nu;
      executable = true;
    };
    home.packages = with pkgs; [
      ripdrag
      timewarrior
      skim
    ];

    services = {
      mpris-proxy.enable = true;
      playerctld.enable = true;
    };
    # xdg.mimeApps = {
    #   enable = true;

    #   defaultApplications = {
    #     "text/html" = "org.chromium.chromium.desktop";
    #     "x-scheme-handler/http" = "org.chromium.chromium.desktop";
    #     "x-scheme-handler/https" = "org.chromium.chromium.desktop";
    #     "x-scheme-handler/about" = "org.chromium.chromium.desktop";
    #     "x-scheme-handler/unknown" = "org.chromium.chromium.desktop";
    #   };
    # };
  };
}
