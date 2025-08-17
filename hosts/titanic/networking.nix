{
  config,
  inputs,
  lib,
  ...
}: {
  imports = [
    ../../modules/networking/tailscale.nix
  ];

  age.secrets.tailscale-auth.file = ../../secrets/tailscale-auth.age;

  modules.networking.tailscale = {
    enable = true;
    authKeyFile = config.age.secrets.tailscale-auth.path;
  };
}
