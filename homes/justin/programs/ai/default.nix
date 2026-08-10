{
  pkgs,
  inputs,
  self,
  config,
  ...
}: {
  imports = [
    # ./t3code.nix
    ./headroom.nix
    inputs.chatgpt-desktop.homeManagerModules.default
  ];
  config = {
    # Keep both the HM source (~/safe) and pi auto-discovery target (~/.pi)
    # under persisted paths from modules/core/common/system/impermanence/module.nix.
    home.file.".pi/agent/extensions/session-auto-renamer.ts" = {
      force = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/safe/nix/homes/justin/programs/ai/pi/session-auto-renamer.ts";
    };

    programs.codexDesktopLinux = {
      enable = true;
      computerUseUi.enable = true;
      remoteMobileControl.enable = true;
      remoteControl.enable = true;
    };

    home.packages = with pkgs;
      [
        rtk
        agent-browser
        pi-coding-agent
        wl-clipboard
        worktrunk
        claude-code
      ]
      ++ [
        (pkgs.lib.lowPrio inputs.seance.packages.${pkgs.stdenv.hostPlatform.system}.seance)
        (inputs.claude-desktop.packages.${system}.claude-desktop.override {
          nodePackages = {inherit (pkgs) asar;};
        })
        # self.packages.${pkgs.stdenv.hostPlatform.system}.cmux-linux
      ];
  };
}
