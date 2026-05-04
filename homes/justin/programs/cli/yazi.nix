{
  pkgs,
  lib,
  ...
}: let
  plugins-repo = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "06e5fe1c7a2a4009c483b28b298700590e7b6784";
    hash = "sha256-jg8+GDsHOSIh8QPYxCvMde1c1D9M78El0PljSerkLQc";
  };
in {
  home.packages = [pkgs.ripdrag];

  xdg.desktopEntries.yazi = {
    name = "Yazi";
    icon = "yazi";
    comment = "Blazing fast terminal file manager written in Rust, based on async I/O";
    exec = "footclient -T yazi yazi %u";
    terminal = false;
    type = "Application";
    mimeType = ["inode/directory"];
    categories = [
      "Utility"
      "Core"
      "System"
      "FileTools"
      "FileManager"
      "ConsoleOnly"
    ];
    # keywords = [
    #   "File"
    #   "Manager"
    #   "Explorer"
    #   "Browser"
    #   "Launcher"
    # ];
  };

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "y";

    settings = {
      manager = {
        sort_by = "mtime";
        show_hidden = true;
      };
      opener = {
        edit = [
          {
            run = "foot -e $EDITOR %s";
            block = true;
            for = "unix";
          }
        ];
      };
      preview = {
        max_width = 1000;
        max_height = 1000;
      };
      sort_by = "mtime";
      sort_reverse = true;
      sort_dir_first = true;
    };

    theme = {
      mgr = {
        cwd = {
          fg = "#0a84ff";
          bold = true;
        };
        hovered = {
          fg = "#f5f5f7";
          bg = "#0a84ff";
          bold = true;
        };
        preview_hovered = {
          fg = "#f5f5f7";
          bg = "#0a84ff";
          bold = true;
        };
        find_keyword = {
          fg = "#ffd60a";
          bold = true;
        };
        find_position = {
          fg = "#f5f5f7";
          bg = "#3a3a3c";
          bold = true;
        };
        marker_copied = {
          fg = "#30d158";
          bg = "#30d158";
        };
        marker_cut = {
          fg = "#ff9f0a";
          bg = "#ff453a";
        };
        marker_marked = {
          fg = "#0a84ff";
          bg = "#64d2ff";
        };
        marker_selected = {
          fg = "#f5f5f7";
          bg = "#0a84ff";
        };
        count_copied = {
          fg = "#1e1e1e";
          bg = "#30d158";
        };
        count_cut = {
          fg = "#1e1e1e";
          bg = "#ff9f0a";
        };
        count_selected = {
          fg = "#f5f5f7";
          bg = "#0a84ff";
        };
        border_symbol = "│";
        border_style.fg = "#3a3a3c";
      };

      tabs = {
        active = {
          fg = "#f5f5f7";
          bg = "#0a84ff";
          bold = true;
        };
        inactive = {
          fg = "#98989d";
          bg = "#1e1e1e";
        };
      };

      mode = {
        normal_main = {
          fg = "#f5f5f7";
          bg = "#0a84ff";
          bold = true;
        };
        normal_alt = {
          fg = "#c7c7cc";
          bg = "#2c2c2e";
        };
        select_main = {
          fg = "#1e1e1e";
          bg = "#30d158";
          bold = true;
        };
        select_alt = {
          fg = "#c7c7cc";
          bg = "#2c2c2e";
        };
        unset_main = {
          fg = "#1e1e1e";
          bg = "#ffd60a";
          bold = true;
        };
        unset_alt = {
          fg = "#c7c7cc";
          bg = "#2c2c2e";
        };
      };

      status = {
        overall.fg = "#98989d";
        sep_left = {
          open = "";
          close = "";
        };
        sep_right = {
          open = "";
          close = "";
        };
        progress_label = {
          fg = "#f5f5f7";
          bold = true;
        };
        progress_normal = {
          fg = "#0a84ff";
          bg = "#2c2c2e";
        };
        progress_error = {
          fg = "#ff453a";
          bg = "#2c2c2e";
        };
        perm_sep.fg = "#636366";
        perm_type.fg = "#64d2ff";
        perm_read.fg = "#30d158";
        perm_write.fg = "#ffd60a";
        perm_exec.fg = "#bf5af2";
      };

      pick = {
        border.fg = "#3a3a3c";
        active = {
          fg = "#0a84ff";
          bold = true;
        };
        inactive.fg = "#98989d";
      };

      input = {
        border.fg = "#3a3a3c";
        title.fg = "#f5f5f7";
        value.fg = "#e5e5ea";
        selected = {
          fg = "#f5f5f7";
          bg = "#0a84ff";
        };
      };

      cmp.border.fg = "#3a3a3c";

      tasks = {
        border.fg = "#3a3a3c";
        title.fg = "#f5f5f7";
        hovered = {
          fg = "#f5f5f7";
          bg = "#0a84ff";
          bold = true;
        };
      };

      which = {
        mask.bg = "#1e1e1e";
        cand = {
          fg = "#0a84ff";
          bold = true;
        };
        rest.fg = "#c7c7cc";
        desc.fg = "#98989d";
        separator = "  ";
        separator_style.fg = "#636366";
      };

      help = {
        on.fg = "#30d158";
        run.fg = "#64d2ff";
        hovered = {
          fg = "#f5f5f7";
          bg = "#0a84ff";
          bold = true;
        };
        footer = {
          fg = "#f5f5f7";
          bg = "#2c2c2e";
        };
      };

      notify = {
        title_info.fg = "#30d158";
        title_warn.fg = "#ff9f0a";
        title_error.fg = "#ff453a";
      };

      filetype.rules = [
        {
          mime = "image/*";
          fg = "#64d2ff";
        }
        {
          mime = "video/*";
          fg = "#bf5af2";
        }
        {
          mime = "audio/*";
          fg = "#bf5af2";
        }
        {
          mime = "application/zip";
          fg = "#ff9f0a";
        }
        {
          mime = "application/x-tar";
          fg = "#ff9f0a";
        }
        {
          mime = "application/x-bzip*";
          fg = "#ff9f0a";
        }
        {
          mime = "application/x-bzip2";
          fg = "#ff9f0a";
        }
        {
          mime = "application/x-7z-compressed";
          fg = "#ff9f0a";
        }
        {
          mime = "application/x-rar";
          fg = "#ff9f0a";
        }
        {
          mime = "application/x-xz";
          fg = "#ff9f0a";
        }
        {
          mime = "application/doc";
          fg = "#64d2ff";
        }
        {
          mime = "application/epub+zip";
          fg = "#64d2ff";
        }
        {
          mime = "application/pdf";
          fg = "#ff453a";
        }
        {
          mime = "application/rtf";
          fg = "#64d2ff";
        }
        {
          mime = "application/vnd.*";
          fg = "#64d2ff";
        }
        {
          url = "*";
          fg = "#f5f5f7";
        }
        {
          url = "*/";
          fg = "#0a84ff";
          bold = true;
        }
      ];
    };

    plugins = {
      # chmod = "${plugins-repo}/chmod.yazi";
      full-border = "${plugins-repo}/full-border.yazi";
      max-preview = "${plugins-repo}/max-preview.yazi";
      starship = pkgs.fetchFromGitHub {
        owner = "Rolv-Apneseth";
        repo = "starship.yazi";
        rev = "0a141f6dd80a4f9f53af8d52a5802c69f5b4b618";
        sha256 = "sha256-OL4kSDa1BuPPg9N8QuMtl+MV/S24qk5R1PbO0jgq2rA";
      };
    };

    initLua = ''
      local function ripdrag(url)
        ya.emit("shell", {
          "ripdrag-sticky " .. ya.quote(tostring(url)),
          confirm = true,
          orphan = true,
        })
      end

      function Entity:click(event, up)
        if up or event.is_middle then
          return
        end

        ya.emit("reveal", { self._file.url })
        if event.is_right then
          ripdrag(self._file.url)
        end
      end
    '';

    keymap = {
      manager.prepend_keymap = [
        {
          on = ["T"];
          run = "plugin --sync max-preview";
          desc = "Maximize or restore the preview pane";
        }
        {
          on = ["c" "m"];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
        {
          on = ["<C-d>"];
          run = ''shell --confirm --orphan ripdrag-sticky "$0"'';
          desc = "Drag the hovered file";
        }
      ];
    };
  };
}
