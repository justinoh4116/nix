{
  lib,
  pkgs,
  config,
  ...
}: let
  sessionizerPath = "${config.home.homeDirectory}/.local/bin/tmux-sessionizer";
  pdfPicker = pkgs.writeTextFile {
    name = "tmux-pdf-picker";
    destination = "/bin/tmux-pdf-picker";
    executable = true;
    text = ''
      #!${lib.getExe pkgs.nushell}

      def collect_pdfs [root: string, fd_path: string] {
        if not ($root | path exists) {
          []
        } else {
          run-external $fd_path "--type" "file" "--extension" "pdf" "." $root
          | lines
          | where { |path| $path != "" }
        }
      }

      def main [selected?: string] {
        let home = $env.HOME
        let textbooks_dir = ($home | path join "safe" "nextcloud" "textbooks")
        let zotero_dir = ($home | path join "safe" "zotero" "storage")
        let fd_path = "${lib.getExe pkgs.fd}"
        let skim_path = "${lib.getExe pkgs.skim}"
        let tmux_path = "${lib.getExe pkgs.tmux}"
        let sioyek_path = "${lib.getExe pkgs.sioyek}"

        let candidates = (
          collect_pdfs $textbooks_dir $fd_path
          | append (collect_pdfs $zotero_dir $fd_path)
          | uniq
          | sort
        )

        if ($candidates | is-empty) {
          exit 0
        }

        let display_candidates = (
          $candidates
          | each { |path|
              if ($path | str starts-with $"($home)/") {
                $path | str replace $"($home)/" ""
              } else {
                $path
              }
            }
        )

        let selected_display = if $selected != null {
          $selected
        } else {
          do -i {
            $display_candidates
            | str join (char newline)
            | run-external $skim_path
            | str trim
          }
        }

        if (($selected_display | default "" | str trim) == "") {
          exit 0
        }

        let resolved_selected = if ($selected_display | str starts-with "/") {
          $selected_display
        } else {
          $home | path join $selected_display
        }

        if not ($resolved_selected | path exists) {
          exit 1
        }

        if (($env.TMUX? | default "") != "") {
          let command = $"exec ($sioyek_path) \"\$PDF_SELECTED\""
          run-external $tmux_path "new-window" "-d" "-e" $"PDF_SELECTED=($resolved_selected)" $command
        } else {
          run-external $sioyek_path $resolved_selected
        }
      }
    '';
  };
in {
  home.packages = [
    pdfPicker
  ];
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    baseIndex = 1;
    newSession = true;
    # Stop tmux+escape craziness.
    escapeTime = 0;
    # Force tmux to use /tmp for sockets (WSL2 compat)
    secureSocket = false;
    mouse = true;
    clock24 = true;
    historyLimit = 50000;

    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.resurrect
      tmuxPlugins.continuum
    ];

    extraConfig = ''
            # change leader
                set -g prefix C-Space
                unbind C-b


                              # https://old.reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/
                              set -g default-terminal "xterm-256color"
                              set -ga terminal-overrides ",*256col*:Tc"
                              set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
                              set-environment -g COLORTERM "truecolor"
                              set -g extended-keys on
                              set -g extended-keys-format csi-u

                              # easy-to-remember split pane commands
                              bind | split-window -h -c "#{pane_current_path}"
                              bind - split-window -v -c "#{pane_current_path}"
                              bind c new-window -c "#{pane_current_path}"
                              unbind t

                              bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded tmux config"
                              bind x kill-window
                              set -g renumber-windows on

                              # vim navigation
                              bind h select-pane -L
                              bind j select-pane -D
                              bind k select-pane -U
                              bind l select-pane -R

                              # Alt+hjkl to switch panes without prefix
                              bind -n M-h select-pane -L
                              bind -n M-j select-pane -D
                              bind -n M-k select-pane -U
                              bind -n M-l select-pane -R

                              # Alt+number to select window
                              bind -n M-1 select-window -t 1
                              bind -n M-2 select-window -t 2
                              bind -n M-3 select-window -t 3
                              bind -n M-4 select-window -t 4
                              bind -n M-5 select-window -t 5
                              bind -n M-6 select-window -t 6
                              bind -n M-7 select-window -t 7
                              bind -n M-8 select-window -t 8
                              bind -n M-9 select-window -t 9
                              bind Space last-window
                              bind C-Space last-window

                        # session and project shortcuts
                        bind n run-shell -b "${sessionizerPath} ${config.home.homeDirectory}/safe/nix"
                        unbind f
                        unbind t
                        unbind n
                        bind f display-popup -E "${sessionizerPath}"
                        bind n display-popup -E "${sessionizerPath} --category notes"
                        bind t display-popup -E "tt"
                        bind p display-popup -E "${lib.getExe pdfPicker}"

                        # Vim-like copy/paste
                        set-window-option -g mode-keys vi
                              bind-key -T copy-mode-vi v send-keys -X begin-selection
                              bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
                              bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
                              unbind -T copy-mode-vi MouseDragEnd1Pane


                              set -g status-position top
      set -g status-justify absolute-centre
      set -g status-style "bg=default"
      set -g window-status-current-style "fg=black bg=white"
      set -g window-status-current-style "fg=colour255,bg=default,bold"
      set -g window-status-separator ""
      set -g window-status-format "#[fg=colour240]#[default] #I:#W#{?window_flags,#{window_flags},} #[fg=colour240]#[default]"
      set -g window-status-current-format "#[fg=colour252]#[default] #I:#W#{?window_flags,#{window_flags},} #[fg=colour252]#[default]"
      set -g status-interval 5
      set -g status-left "#S"
      set -g status-right ""
    '';
  };
}
