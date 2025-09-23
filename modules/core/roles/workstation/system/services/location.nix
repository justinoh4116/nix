{config, ...}: {
  services.geoclue2 = {
    enable = true;
    enableWifi = false;
    enable3G = false;
  };
}
