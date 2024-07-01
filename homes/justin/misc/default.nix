{
  self,
  inputs,
  config,
  opts,
  ...
}: {
  imports = [
    ./gammastep.nix
    ./dconf.nix
  ];

  config = {
    home.xdg.mimeApps = {
      enable = true;

      defaultApplications = {
        "text/html" = "org.chromium.chromium.desktop";
        "x-scheme-handler/http" = "org.chromium.chromium.desktop";
        "x-scheme-handler/https" = "org.chromium.chromium.desktop";
        "x-scheme-handler/about" = "org.chromium.chromium.desktop";
        "x-scheme-handler/unknown" = "org.chromium.chromium.desktop";
      };
    };
  };
}
