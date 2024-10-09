return {
	{
		"isakbm/gitgraph.nvim",
		---@type I.GGConfig
		opts = {
			symbols = {
				merge_commit = "",
				commit = "",
				merge_commit_end = "",
				commit_end = "",

				-- Advanced symbols
				GVER = "",
				GHOR = "",
				GCLD = "",
				GCRD = "╭",
				GCLU = "",
				GCRU = "",
				GLRU = "",
				GLRD = "",
				GLUD = "",
				GRUD = "",
				GFORKU = "",
				GFORKD = "",
				GRUDCD = "",
				GRUDCU = "",
				GLUDCD = "",
				GLUDCU = "",
				GLRDCL = "",
				GLRDCR = "",
				GLRUCL = "",
				GLRUCR = "",
			},
			format = {
				timestamp = "%H:%M:%S %d-%m-%Y",
				fields = { "hash", "timestamp", "author", "branch_name", "tag" },
			},
			hooks = {
				on_select_commit = function(commit)
					print("selected commit:", commit.hash)
				end,
				on_select_range_commit = function(from, to)
					print("selected range:", from.hash, to.hash)
				end,
			},
		},
		keys = {
			{
				"<leader>gl",
				function()
					require("gitgraph").draw({}, { all = true, max_count = 5000 })
				end,
				desc = "GitGraph - Draw",
			},
		},
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
				keymaps = {
					visual = "<C-s>",
				},
			})
		end,
	},
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		version = "*",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		opts = {
			-- configurations go here
		},
	},
	{
		"altermo/ultimate-autopair.nvim",
		event = { "InsertEnter", "CmdlineEnter" },
		branch = "v0.6", --recommended as each new version will have breaking changes
		opts = {
			--Config goes here
		},
	},
	{ "tpope/vim-fugitive" },
	-- {
	--     'f-person/git-blame.nvim',
	--     event = { 'BufReadPre', 'BufNewFile' },
	--     init = function ()
	--         vim.g.gitblame_delay = 750
	--     end
	-- },
	{ "Bekaboo/deadcolumn.nvim" },
	{
		"chrisgrieser/nvim-spider",
		lazy = true,
	},
	{
		"tzachar/highlight-undo.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("highlight-undo").setup({})
		end,
	},
	-- {
	--     'Eandrju/cellular-automaton.nvim',
	--     keys = {
	--         { '<leader>zz' , '<cmd>CellularAutomaton make_it_rain<cr>' },
	--     },
	-- },
	-- {
	--     'lewis6991/satellite.nvim',
	--     config = true,
	--     event = { 'BufReadPre', 'BufNewFile' },
	-- },
	{
	-- 	"iurimateus/luasnip-latex-snippets.nvim",
	-- 	config = function()
	-- 		--require'luasnip-latex-snippets'.setup()
	-- 		require("luasnip-latex-snippets").setup({ use_treesitter = true })
	-- 		require("luasnip").config.setup({ enable_autosnippets = true })
	-- 	end,
	-- 	ft = { "tex" },
	-- },
	{
		"rafamadriz/friendly-snippets",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			-- require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
	{
	    'lervag/vimtex',
	    event = { 'BufReadPre', 'BufNewFile' },
	    init = function()
	        vim.g.tex_flavor='latex'
	        vim.g.vimtex_view_method='zathura'
	        vim.g.vimtex_quickfix_mode=0
	        vim.opt.conceallevel=0
	        vim.g.vimtex_fold_enabled=0
	        -- vim.g.tex_conceal='abdmg'
	    end

	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "folke/trouble.nvim", lazy = true },
		config = function()
			require("gitsigns").setup()
			-- require('scrollbar.handlers.gitsigns').setup()
		end,
	},

	{
		"chentoast/marks.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = true,
	},

	-- {
	--     'altermo/ultimate-autopair.nvim',
	--     event={'InsertEnter','CmdlineEnter'},
	--     config=function ()
	--         require('ultimate-autopair').setup({
	--             --Config goes here
	--         })
	--     end,
	-- },

	{
		"folke/trouble.nvim",
		module = true,
		cmd = {
			"Trouble",
			"TroubleToggle",
		},
		opts = { use_diagnostic_signs = true },
		keys = {
			{ "<leader>tt", "<cmd>TroubleToggle document_diagnostics<cr>", "Trouble document diagnostics" },
			{ "<leader>tT", "<cmd>TroubleToggle workspace_diagnostics<cr>", "Trouble workspace diagnostics" },
		},
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("trouble").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	},

	"nvim-tree/nvim-web-devicons",

	--     {
	--         "Maan2003/lsp_lines.nvim",
	--         event = { 'BufReadPre', 'BufNewFile' },
	--         config = function()
	--             require("lsp_lines").setup()
	--         end,
	--     },

	{
		"SmiteshP/nvim-navic",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = "neovim/nvim-lspconfig",
	},

	{
		"RRethy/vim-illuminate",
		event = {
			"BufReadPost",
			"BufNewFile",
		},
	},

	{
		"norcalli/nvim-colorizer.lua",
		ft = { "css", "js", "tsx", "jsx" },
		event = { "BufReadPre", "BufNewFile" },
		config = true,
		opts = function()
			vim.cmd.ColorizerToggle()
		end,
	},
}
