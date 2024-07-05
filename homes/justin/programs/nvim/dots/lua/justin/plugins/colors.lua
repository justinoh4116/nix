-- Sets colors to line numbers Above, Current and Below  in this order
-- function LineNumberColors()
--   vim.api.nvim_set_hl(0, 'LineNrAbove', { fg='#6C6F85' })
--   vim.api.nvim_set_hl(0, 'LineNr', { fg='#6C6F85', bold=true })
--   vim.api.nvim_set_hl(0, 'LineNrBelow', { fg='#6C6F85' })
-- end

return {
    -- "folke/tokyonight.nvim",
    -- lazy = false,
    -- priority = 1000,
    -- opts = {},
    -- config = function()
    --     vim.cmd[[colorscheme tokyonight]]
    --     LineNumberColors()
    -- end,
    -- {
    --   "scottmckendry/cyberdream.nvim",
    --   lazy = false,
    --   priority = 1000,
    --   opts = {
    --     transparent = true,
    --   },
    --   config = function()
    --     vim.cmd[[colorscheme cyberdream]]
    --   end
    -- },
    {
      'catppuccin/nvim',
      lazy = true,
      name = 'catppuccin',
      config = {
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = { -- :h background
          light = "latte",
          dark = "mocha",
        },
        transparent_background = false,
        show_end_of_buffer = false, -- show the '~' characters after the end of buffers
        term_colors = false,
        dim_inactive = {
          enabled = true,
          shade = "dark",
          percentage = 0.15,
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        color_overrides = {},
        custom_highlights = {},
        integrations = {
          fidget = {
            enabled = true,
          },
          navic = {
            enabled = true,
          },
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = {},
              hints = {},
              warnings = {},
              information = {},
            },
          },
          -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        },
      },
      init = function() vim.cmd.colorscheme "catppuccin" end
    }
  }
