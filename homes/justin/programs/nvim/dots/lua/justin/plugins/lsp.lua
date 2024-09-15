capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }
return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{
				{
					"SmiteshP/nvim-navbuddy",
					keys = {
						{ "<leader>nn", "<cmd>Navbuddy<CR>" },
					},
					dependencies = {
						{
							"SmiteshP/nvim-navic",
							dependencies = {},
							opts = {
								lsp = {
									auto_attach = true,
								},
							},
						},
						"MunifTanjim/nui.nvim",
					},
					opts = { lsp = { auto_attach = true } },
				},
			},
			"simrat39/rust-tools.nvim",
			{
				"folke/neodev.nvim",
				config = true,
			},
			{
				"hrsh7th/cmp-nvim-lsp",
				config = true,
				dependencies = {
					{
						"VonHeikemen/lsp-zero.nvim",
						branch = "v3.x",
						lazy = true,
						config = false,
						init = function()
							-- Disable automatic setup, we are doing it manually
							vim.g.lsp_zero_extend_cmp = 0
							vim.g.lsp_zero_extend_lspconfig = 0
						end,
					},
					-- 'williamboman/mason-lspconfig.nvim',
					-- config = true,
					-- dependencies = {
					--     'williamboman/mason.nvim',
					--     config = true,
					-- },
				},
			},
		},
		config = function()
			-- This is where all the LSP shenanigans will live
			local lsp_zero = require("lsp-zero")
			lsp_zero.extend_lspconfig({
				sign_text = true,
				capabilities = capabilities,
			})

			lsp_zero.on_attach(function(client, bufnr)
				-- see :help lsp-zero-keybindings
				-- to learn the available actions
				lsp_zero.default_keymaps({ buffer = bufnr, exclude = { "<F3>" } })
				vim.keymap.set("n", "gI", "<cmd>Telescope lsp_implementations<cr>", { buffer = bufnr })
				vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { buffer = bufnr })
				vim.keymap.set("n", "<leader>cl", "<cmd>LspInfo<cr>", { buffer = bufnr })
				vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, { buffer = bufnr })
				vim.keymap.set("i", "<c-k>", vim.lsp.buf.signature_help, { buffer = bufnr })
				vim.keymap.set("n", "gI", "<cmd>Telescope lsp_implementations<cr>", { buffer = bufnr })
			end)

			-- PUT THE LSPs HERE
			require("lspconfig").arduino_language_server.setup({})
			require("lspconfig").nil_ls.setup({})
			require("lspconfig").tsserver.setup({})
			-- require('lspconfig').texlab.setup{}
			require("lspconfig").clangd.setup({})
			require("lspconfig").pyright.setup({})

			-- (Optional) Configure lua language server for neovim
			local lua_opts = lsp_zero.nvim_lua_ls()
			require("lspconfig").lua_ls.setup(lua_opts)
		end,
		-- config = function()
		--     local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
		--     local lsp_attach = function(_, bufnr)
		--         vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { buffer = bufnr })
		--         vim.keymap.set('n', '<leader>cl', '<cmd>LspInfo<cr>', { buffer = bufnr })
		--         vim.keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<cr>', { buffer = bufnr })
		--         vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', { buffer = bufnr })
		--         vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr })
		--         vim.keymap.set('n', 'gI', '<cmd>Telescope lsp_implementations<cr>', { buffer = bufnr })
		--         vim.keymap.set('n', 'gt', '<cmd>Telescope lsp_type_definitions<cr>', { buffer = bufnr })
		--         vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
		--         vim.keymap.set('n', 'gK', vim.lsp.buf.signature_help, { buffer = bufnr })
		--         vim.keymap.set('i', '<c-k>', vim.lsp.buf.signature_help, { buffer = bufnr })
		--     end

		--     vim.diagnostic.config({
		--         -- virtual_text = false,
		--     })

		--     local lspconfig = require('lspconfig')
		--     require('mason-lspconfig').setup_handlers({
		--         function(server_name)
		--             lspconfig[server_name].setup({
		--                 on_attach = lsp_attach,
		--                 capabilities = lsp_capabilities,
		--             })
		--         end,
		--         ['rust_analyzer'] = function ()
		--             require('rust-tools').setup({
		--                 server = {
		--                     capabilities = lsp_capabilities,
		--                     on_attach = function(_, bufnr)
		--                         vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { buffer = bufnr })
		--                         vim.keymap.set('n', '<leader>cl', '<cmd>LspInfo<cr>', { buffer = bufnr })
		--                         vim.keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<cr>', { buffer = bufnr })
		--                         vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', { buffer = bufnr })
		--                         vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr })
		--                         vim.keymap.set('n', 'gI', '<cmd>Telescope lsp_implementations<cr>', { buffer = bufnr })
		--                         vim.keymap.set('n', 'gt', '<cmd>Telescope lsp_type_definitions<cr>', { buffer = bufnr })
		--                         vim.keymap.set('n', 'K', '<cmd>RustHoverActions<cr>', { buffer = bufnr })
		--                         vim.keymap.set('n', 'gK', vim.lsp.buf.signature_help, { buffer = bufnr })
		--                         vim.keymap.set('i', '<c-k>', vim.lsp.buf.signature_help, { buffer = bufnr })
		--                     end,
		--                 },
		--             lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
		--             })
		--             -- require'rust-tools'.hover_actions.hover_actions()
		--             -- require('rust-tools').runnables.runnables()
		--         end
		--     })
		-- end,
	},
}
