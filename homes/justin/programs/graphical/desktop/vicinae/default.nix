{
  inputs,
  pkgs,
  lib,
  osConfig,
  ...
}: let
  cfg = osConfig.modules.usrEnv.desktop.launchers.vicinae;
  desktop = osConfig.modules.usrEnv.desktop;
  soulverDataDir = "/home/justin/.local/share";
  soulverLibDir = "/home/justin/.local/lib/soulver-cpp";
  swiftRuntimeLibDir = "/home/justin/.local/lib/swift-6.1/lib/swift/linux";
  wrappedVicinae = pkgs.symlinkJoin {
    name = "vicinae-with-soulver-runtime";
    paths = [inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/vicinae \
        --prefix LD_LIBRARY_PATH : ${lib.escapeShellArg "${soulverLibDir}:${swiftRuntimeLibDir}"} \
        --prefix XDG_DATA_DIRS : ${lib.escapeShellArg soulverDataDir}
    '';
  };
in {
  imports = [inputs.vicinae.homeManagerModules.default];

  config = lib.mkIf cfg.enable {
    services.vicinae = {
      enable = true;
      package = wrappedVicinae;
      systemd.enable = true;

      settings = {
        close_on_focus_loss = true;
        theme = {
          light = {
            name = "vicinae-light";
            icon_theme = "default";
          };
          dark = {
            name = "vicinae-dark";
            icon_theme = "default";
          };
        };

        launcher_window = {
          opacity = 0.5;
          # Let Niri own the window shape so the global rounded-corner rule applies.
          client_side_decorations.enabled = false;
          layer_shell.enabled = false;
        };

        providers = {
          "@Gelei/bluetooth-0" = {
            preferences = {
              connectionToggleable = true;
            };
          };
        };
      };

      extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
        # bluetooth
        nix
        wifi-commander
      ];
    };
  };
}
