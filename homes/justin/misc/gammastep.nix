{
  inputs,
  cfg,
  opts,
  ...
}: {
  services.gammastep = {
    enable = true;
    tray = true;
    provider = "geoclue2";
  };
}
