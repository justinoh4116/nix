{
  pkgs,
  inputs,
  self,
  config,
  ...
}: {
  imports = [
    ./codex.nix
    ./t3code.nix
    ./headroom.nix
  ];
  config = {
    # Keep both the HM source (~/safe) and pi auto-discovery target (~/.pi)
    # under persisted paths from modules/core/common/system/impermanence/module.nix.
    home.file.".pi/agent/extensions/session-auto-renamer.ts" = {
      force = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/safe/nix/homes/justin/programs/ai/pi/session-auto-renamer.ts";
    };

    home.packages = with pkgs;
      [
        rtk
        agent-browser
        pi-coding-agent
        wl-clipboard
        worktrunk
      ]
      ++ [
        (pkgs.lib.lowPrio inputs.seance.packages.${pkgs.stdenv.hostPlatform.system}.seance)
        # self.packages.${pkgs.stdenv.hostPlatform.system}.cmux-linux
      ];
  };
}
