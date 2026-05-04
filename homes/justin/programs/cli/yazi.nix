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
  flavors-repo = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "flavors";
    rev = "2d7dd2afe253c30943e9cd05158b1560a285eeab";
    sha256 = "sha256-566RFL1Wng7yr5OS3UtKEy+ZLrgwfCdX9FAtwRQK2oM";
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
      flavor = {
        use = "modus-vivendi";
      };
    };

    flavors = {
      catppuccin-frappe = "${flavors-repo}/catppuccin-frappe.yazi";
      modus-vivendi = pkgs.fetchFromGitHub {
        owner = "azzamsa";
        repo = "modus.yazi";
        rev = "150e2c09a07d53bbfe3e89a722a88cdad46e7bc5";
        hash = "sha256-bUq6DwKALExm5mH/sdUoq3APU5uT7PLjbF/f5/wKDSQ=";
      };
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
