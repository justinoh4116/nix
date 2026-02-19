{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  inherit (osConfig) modules;
  inherit (modules.style.colorScheme) colors;
in {
  config = lib.mkIf osConfig.modules.system.programs.gui.enable {
    programs.wezterm = {
      enable = true;
      colorSchemes = import ./colorSchemes.nix {inherit colors;};
      extraConfig = ''
        local wez = require("wezterm")
        local act = wezterm.action
        local baseConfig = {
         -- general
         check_for_updates = false, -- nix has updates covered, I don't care about updates
         exit_behavior = "CloseOnCleanExit",
         enable_scroll_bar = false,
         audible_bell = "Disabled", -- annoying
           warn_about_missing_glyphs =  false,

         key_bindings = {

           -- bashrc has the kill-backward commands now which covers us in most terminals. Should not be made specific to wezterm. The shortcuts are here incase needed in future.
           -- Use one of these
           -- { key = 'Backspace', mods = 'CTRL', action = act.SendKey {key = 'Backspace', mods = 'ALT'} },
           -- most Linux shells use Alt + backspace instead for word backspace
           { key = 'Backspace', mods = 'CTRL', action = act.SendKey {key = 'w', mods = 'CTRL'} }
           -- most Linux shells use Ctrl + w instead for word delete
         },

         -- anims
           animation_fps = 1,

         -- term window settings
         adjust_window_size_when_changing_font_size = false,
         -- window_background_opacity = 0.85,
         window_background_opacity = 1,
         window_padding = { left = 12, right = 12, top = 12, bottom = 12, },
         window_close_confirmation = "NeverPrompt",
         inactive_pane_hsb = {
          saturation = 1.0,
          brightness = 0.8
         },

         -- cursor
         default_cursor_style = "SteadyBar",
         cursor_blink_rate = 700,
         cursor_blink_ease_in = 'Constant',
         cursor_blink_ease_out = 'Constant',

         -- tab bar
         enable_tab_bar = true, -- no observable performance impact
         use_fancy_tab_bar = false,
         hide_tab_bar_if_only_one_tab = true,
         show_tab_index_in_tab_bar = false,

         -- font config
         font_size = 13.0,
         font = wezterm.font('IosevkaTerm Nerd Font'),
         harfbuzz_features = { 'calt=0', 'VRLG' },

         -- perf
         front_end = "WebGpu",
         enable_wayland = true,
         scrollback_lines = 10000,

         -- colors
         color_scheme = "followSystem",
        }

        return baseConfig
      '';
    };
  };
}
