{
  self,
  inputs,
  lib,
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    cachix
  ];

  services.cachix-agent = {
    enable = true;
    credentialsFile = config.age.secrets.cachix-agent-token.path;
  };

  age.secrets.cachix-agent-token.file = ../../secrets/cachix-agent-token.age;
}
