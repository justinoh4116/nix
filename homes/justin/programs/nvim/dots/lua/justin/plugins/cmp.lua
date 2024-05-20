return {
    'hrsh7th/nvim-cmp',
    version = false, -- last release is way too old
    event = 'InsertEnter',
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        {
          'L3MON4D3/LuaSnip',
          opts = {
            enable_autosnippets = true,
          },
        },
        'saadparwaiz1/cmp_luasnip',
        'neovim/nvim-lspconfig',
    },
    opts = function()
        local cmp = require('cmp')
        local luasnip = require('luasnip')
        local lsp_zero = require('lsp-zero')
        local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        lsp_zero.extend_cmp()

        return {
            preselect = cmp.PreselectMode.None,
            completion = {
                completeopt = 'menu,menuone,noinsert,noselect',
            },
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<Tab>"] = cmp.mapping(function(fallback)
                    -- if cmp.visible() then
                    --     cmp.select_next_item()
                    --     -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
                    --     -- they way you will only jump inside the snippet region
                    if luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    -- if cmp.visible() then
                    --     cmp.select_prev_item()
                    if luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                ['<C-n>'] = cmp.mapping.select_next_item(),
                ['<C-p>'] = cmp.mapping.select_prev_item(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'buffer' },
                { name = 'path' },
            }),
            experimental = {
                ghost_text = {
                    hl_group = 'LspCodeLens',
                },
            },
        }
    end,
}
