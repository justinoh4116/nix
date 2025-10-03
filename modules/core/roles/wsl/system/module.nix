{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./ssh-agent.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = "justin";
}
