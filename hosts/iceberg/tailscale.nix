{
self,
inputs, 
  lib,
  pkgs,
  ...
  }: {
  services.tailscale = {
    enable = true;
    openFirewall = true;
    authKeyFile = config.age.secrets.tailscale-auth.path;
    # extraUpFlags = [
    #   "--login-server=https://your-instance" # if you use a non-default tailscale coordinator
    #   "--accept-dns=false" # if its' a server you prolly dont need magicdns
    # ];
  };

  age.secrets.vpn-preauth.file = ../secrets/tailscale-auth.age;
  }
