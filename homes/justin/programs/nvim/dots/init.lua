vim.o.nu = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.signcolumn = "yes"
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.g.mapleader = " "
vim.o.winborder = "rounded"
vim.o.swapfile = false
vim.o.termguicolors = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99

vim.api.nvim_create_user_command("DiffOrig", function()
	local file = vim.fn.expand("%:p")
	if file == "" then
		vim.notify("DiffOrig: current buffer has no file", vim.log.levels.WARN)
		return
	end

	vim.cmd("vert new")
	vim.bo.buftype = "nofile"
	vim.bo.bufhidden = "wipe"
	vim.bo.swapfile = false
	vim.cmd("read ++edit " .. vim.fn.fnameescape(file))
	vim.cmd("0delete_")
	vim.cmd("diffthis")
	vim.cmd("wincmd p")
	vim.cmd("diffthis")
end, { desc = "Diff current buffer against the file on disk" })

vim.pack.add({
	{ src = "https://github.com/saghen/blink.lib" },
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/tamton-aquib/keys.nvim" },
	{ src = "https://github.com/OXY2DEV/markview.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/chentoast/marks.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim", version = "master" },
	{ src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
	{ src = "https://github.com/tpope/vim-fugitive" },
})

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local treesitter = require("nvim-treesitter")
		local lang = vim.treesitter.language.get_lang(args.match)
		if vim.list_contains(treesitter.get_available(), lang) then
			if not vim.list_contains(treesitter.get_installed(), lang) then
				treesitter.install(lang):wait()
			end
			vim.treesitter.start(args.buf)
		end
	end,
	desc = "Enable nvim-treesitter and install parser if not installed",
})

require("oil").setup()

local telescope = require("telescope")
local default_color = "vague"
telescope.setup({
	defaults = {
		-- preview = { treesitter = true },
		color_devicons = true,
		sorting_strategy = "ascending",
		borderchars = {
			"", -- top
			"", -- right
			"", -- bottom
			"", -- left
			"", -- top-left
			"", -- top-right
			"", -- bottom-right
			"", -- bottom-left
		},
		path_displays = { "smart" },
		layout_config = {
			height = 100,
			width = 400,
			prompt_position = "top",
			preview_cutoff = 40,
		},
	},
})
telescope.load_extension("ui-select")

local builtin = require("telescope.builtin")

require("typst-preview").setup({
	debug = true,
	-- open_cmd = "open helium://%s",
	-- port = 4567, -- random if not set
	dependencies_bin = {
		tinymist = "/etc/profiles/per-user/justin/bin/tinymist",
		websocat = "/etc/profiles/per-user/justin/bin/websocat",
	},
})

-- colors
require("vague").setup({ transparent = true })
vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")

local map = vim.keymap.set
map("n", "<F3>", vim.lsp.buf.format)
map("n", "-", ":Oil<CR>")
map("n", "<leader>w", ":update<CR>")
map("n", "<leader>q", ":quit<CR>")
map("n", "<leader>Q", ":wqa<CR>")
map("n", "<leader>v", ":e $MYVIMRC <CR>")
map("n", "<leader>t", ":e ~/do <CR>")

map({ "n", "v", "x" }, "<leader>y", '"+y')
map({ "n", "v", "x" }, "<leader>d", '"+d<CR>')

map({ "n", "v" }, "<leader>n", ":norm ")
map({ "n", "v", "x" }, "<C-s>", [[:s/\V]], { desc = "Enter substitue mode in selection" })

map("n", "<leader>gs", vim.cmd.Git)

-- snippets
require("luasnip").setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/snippets" })

local ls = require("luasnip")

vim.lsp.enable({
	"svelte",
	"lua_ls",
	"svelte-language-server",
	"tinymist",
	"clangd",
	"verible",
	"pyright",
	"rust_analyzer",
	"nil_ls",
	"arduino_language_server",
	"nushell",
	"ccls",
})
map("i", "<C-e>", function()
	ls.expand()
end, { silent = true })
map({ "i", "s" }, "<C-J>", function()
	ls.jump(1)
end, { silent = true })
map({ "i", "s" }, "<C-K>", function()
	ls.jump(-1)
end, { silent = true })

map({ "n" }, "<leader>ff", builtin.find_files, { desc = "Telescope live grep" })

function git_files()
	builtin.find_files({ no_ignore = true })
end

map({ "n" }, "<C-p>", builtin.live_grep)
map({ "n" }, "<leader>sg", git_files)
map({ "n" }, "<leader>sb", builtin.buffers)
map({ "n" }, "<leader>si", builtin.grep_string)
map({ "n" }, "<leader>so", builtin.oldfiles)
map({ "n" }, "<leader>sh", builtin.help_tags)
map({ "n" }, "<leader>sm", builtin.man_pages)
map({ "n" }, "<leader>G", builtin.git_commits)
map({ "n" }, "<leader>sr", builtin.lsp_references)
map({ "n" }, "<leader>sd", builtin.diagnostics)
-- map({ "n" }, "<leader>si", builtin.lsp_implementations)
map({ "n" }, "<leader>sT", builtin.lsp_type_definitions)
map({ "n" }, "<leader>ss", builtin.current_buffer_fuzzy_find)
map({ "n" }, "<leader>st", builtin.builtin)
map({ "n" }, "<leader>sc", builtin.git_bcommits)
map({ "n" }, "<leader>sk", builtin.keymaps)

local cmp = require("blink.cmp")
-- cmp.build():wait(60000)
cmp.setup({
	fuzzy = { implementation = "lua" },
	completion = {
		menu = {
			border = "none",
			draw = { columns = { { "label", "label_description", gap = 1 } } },
		},
	},
	sources = { default = { "lsp", "path", "buffer" } },
	cmdline = { enabled = false },
})

-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = vim.api.nvim_create_augroup("my.lsp", {}),
--   callback = function(args)
--     local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
--     if client:supports_method("textDocument/completion") then
--       -- Optional: trigger autocompletion on EVERY keypress. May be slow!
--       local chars = {}
--       for i = 32, 126 do
--         table.insert(chars, string.char(i))
--       end
--       client.server_capabilities.completionProvider.triggerCharacters = chars
--       vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
--     end
--   end,
-- })
vim.cmd("set completeopt+=noselect")

require("marks").setup({
	builtin_marks = { ".", "<", ">", "^" },
	-- whether movements cycle back to the beginning/end of buffer. default true
	cyclic = true,
})
