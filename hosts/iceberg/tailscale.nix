{
  self,
  inputs,
  lib,
  pkgs,
  config,
  ...
}: {
  age.secrets.tailscale-auth.file = ../../secrets/tailscale-auth.age;

  services.tailscale = {
    enable = true;
    openFirewall = true;
    authKeyFile = config.age.secrets.tailscale-auth.path;
    extraUpFlags = [
      # "--advertise-exit-node"
      #   "--login-server=https://your-instance" # if you use a non-default tailscale coordinator
      #   "--accept-dns=false" # if its' a server you prolly dont need magicdns
    ];
  };
}
