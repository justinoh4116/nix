return
{
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            'simrat39/rust-tools.nvim',
            {
                'folke/neodev.nvim',
                config = true,
            },
            {
                'hrsh7th/cmp-nvim-lsp',
                config = true,
                dependencies = {
                    'williamboman/mason-lspconfig.nvim',
                    config = true,
                    dependencies = {
                        'williamboman/mason.nvim',
                        config = true,
                    },
                },
            },
        },
        config = function()
            local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
            local lsp_attach = function(_, bufnr)
                vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { buffer = bufnr })
                vim.keymap.set('n', '<leader>cl', '<cmd>LspInfo<cr>', { buffer = bufnr })
                vim.keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<cr>', { buffer = bufnr })
                vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', { buffer = bufnr })
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr })
                vim.keymap.set('n', 'gI', '<cmd>Telescope lsp_implementations<cr>', { buffer = bufnr })
                vim.keymap.set('n', 'gt', '<cmd>Telescope lsp_type_definitions<cr>', { buffer = bufnr })
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
                vim.keymap.set('n', 'gK', vim.lsp.buf.signature_help, { buffer = bufnr })
                vim.keymap.set('i', '<c-k>', vim.lsp.buf.signature_help, { buffer = bufnr })
            end

            vim.diagnostic.config({
                -- virtual_text = false,
            })

            local lspconfig = require('lspconfig')
            require('mason-lspconfig').setup_handlers({
                function(server_name)
                    lspconfig[server_name].setup({
                        on_attach = lsp_attach,
                        capabilities = lsp_capabilities,
                    })
                end,
                ['rust_analyzer'] = function ()
                    require('rust-tools').setup({
                        server = {
                            capabilities = lsp_capabilities,
                            on_attach = function(_, bufnr)
                                vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { buffer = bufnr })
                                vim.keymap.set('n', '<leader>cl', '<cmd>LspInfo<cr>', { buffer = bufnr })
                                vim.keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<cr>', { buffer = bufnr })
                                vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', { buffer = bufnr })
                                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr })
                                vim.keymap.set('n', 'gI', '<cmd>Telescope lsp_implementations<cr>', { buffer = bufnr })
                                vim.keymap.set('n', 'gt', '<cmd>Telescope lsp_type_definitions<cr>', { buffer = bufnr })
                                vim.keymap.set('n', 'K', '<cmd>RustHoverActions<cr>', { buffer = bufnr })
                                vim.keymap.set('n', 'gK', vim.lsp.buf.signature_help, { buffer = bufnr })
                                vim.keymap.set('i', '<c-k>', vim.lsp.buf.signature_help, { buffer = bufnr })
                            end,
                        },
                    lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
                    })
                    -- require'rust-tools'.hover_actions.hover_actions()
                    -- require('rust-tools').runnables.runnables()
                end
            })
        end,
    },
}
