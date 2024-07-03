return {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = {
        { "abeldekat/harpoonline", version = "*" },
        { 'nvim-tree/nvim-web-devicons', lazy = true },
        { 'folke/noice.nvim' },
    },
        config = function ()

          local Harpoonline = require("harpoonline")
          Harpoonline.setup({
            on_update = function() require("lualine").refresh() end,
          })

          require('lualine').setup {
            options = {
                icons_enabled = true,
                theme = 'tokyonight',
                component_separators = { left = '', right = ''},
                section_separators = { left = '', right = ''},
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                globalstatus = true,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                }
            },
            sections = {
                lualine_a = {'mode'},
                lualine_b = {'branch', 'diff', 'diagnostics'},
                lualine_c = { Harpoonline.format, 'filename'},
                lualine_x = {
                    -- {
                    --     function() return require('noice').api.statusline.mode.get() end,
                    --     cond = function() require('noice').api.statusline.mode.has() end,
                    --     color = { fg = '#ff9e64' },
                    -- },
                    {
                        function() return string.gsub(require("noice").api.status.mode.get(), ".+(@.)", "recording %1") end,
                        cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() and (string.find(require('noice').api.status.mode.get(), 'recording') ~= fail) end,
                        color = { fg = '#F2CDCD' },
                    },
                    'encoding',
                    'fileformat',
                    'filetype',
                },
                lualine_y = {'progress'},
                lualine_z = {'location'}
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {'filename'},
                lualine_x = {'location'},
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {}

        }
      end

}
