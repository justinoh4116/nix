{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.modules.system.services.minecraft;
in {
  config = lib.mkIf cfg.enable {
    services.minecraft-server = {
      enable = true;
      package = pkgs.papermcServers.papermc-1_21_1;
      eula = true;
      openFirewall = true; # Opens the port the server is running on (by default 25565 but in this case 43000)
      declarative = true;
      whitelist = {
        Panguin123 = "c7cc7afb-05f5-482a-86fa-aa93f4001999";
        Dezedz = "e30b578a-f776-46bf-a07a-e4e5aeb87a60";
        Bubbelz = "0e37b8ba-faa6-425c-87f9-a4d414b8462d";
      };
      serverProperties = {
        server-port = 34197;
        difficulty = 3;
        gamemode = 1;
        max-players = 5;
        motd = "aweg";
        white-list = true;
        allow-cheats = true;
      };
      jvmOpts = "-Xms2048M -Xmx4096M";
    };
  };
}
