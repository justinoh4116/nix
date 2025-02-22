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
    credentialsFile = config.age.secrets.framework-cachix-agent-token.path;
  };

  age.secrets.framework-cachix-agent-token.file = ../../secrets/framework-cachix-agent-token.age;
}
