args @ {pkgs, ...}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # disable greeting
    '';
    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }
      {
        name = "puffer";
        src = pkgs.fishPlugins.puffer.src;
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
    ];
    shellInit = ''
      set -gx $EDITOR "nvim"
      set fzf_directors_opts --bind "ctrl-0:execute($EDITOR {} &> /dev/tty)"
      set -gx PF_INFO "title os host kernel pkgs uptime memory wm palette"

      if command -q nix-your-shell
          nix-your-shell fish | source
      end
    '';

    functions = {
      fish_user_key_bindings = {
        body = "fish_vi_key_bindings";
      };

      fish_greeting = {
        body = "pfetch";
      };
    };
  };
}
