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
    credentialsFile = config.age.secrets.iceberg-cachix-agent-token.path;
  };

  age.secrets.iceberg-cachix-agent-token.file = ../../secrets/iceberg-cachix-agent-token.age;
}
