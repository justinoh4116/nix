{
  lib,
  keys,
  ...
}: let
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) enum str listOf;
in {
  options.modules.system.programs = {
    gui.enable = mkEnableOption "graphical program suite" // {default = true;};
    cli.enable = mkEnableOption "cli program suite" // {default = true;};
    dev.enable = mkEnableOption "dev enviroment program suite";

    fish.enable = mkEnableOption "fish shell system-wide";
    discord.enable = mkEnableOption "discord";
    webcord.enable = mkEnableOption "webcord discord client";
    spotify.enable = mkEnableOption "spotify";
    zathura.enable = mkEnableOption "zathura pdf viewer";
    nextcloud.enable = mkEnableOption "nextcloud sync client";
    steam.enable = mkEnableOption "steam";

    editors = {
      neovim.enable = mkEnableOption "neovim editor";
      helix.enable = mkEnableOption "helix editor";
      vscode.enable = mkEnableOption "vscode";
    };

    browsers = {
      nyxt.enable = mkEnableOption "nyxt browser";
      zen.enable = mkEnableOption "zen browser";
      firefox.enable = mkEnableOption "firefox";
      floorp.enable = mkEnableOption "floorp";
      chromium.enable = mkEnableOption "chromium";
    };

    terminals = {
      kitty.enable = mkEnableOption "kitty terminal";
      wezterm.enable = mkEnableOption "wezterm terminal";
      alacritty.enable = mkEnableOption "alacritty terminal";
    };

    git = {
      signingKey = mkOption {
        default = "/home/justin/.ssh/id_ed25519_sk.pub";
        type = str;
      };
    };

    # default programs
    default = {
      browser = mkOption {
        type = enum ["chromium" "zen" "nyxt" "firefox"];
        default = "zen";
      };
      terminal = mkOption {
        type = enum ["kitty" "wezterm" "alacritty"];
        default = "kitty";
      };
      launcher = mkOption {
        type = enum ["anyrun" "wofi" "rofi"];
        default = "anyrun";
      };
      editor = mkOption {
        type = enum ["neovim" "vscode" "helix"];
        default = "neovim";
      };
    };
  };
}
