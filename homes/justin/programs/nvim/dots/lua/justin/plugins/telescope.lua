local function telescope(builtin)
	local params = { builtin = builtin }
	return function()
		builtin = params.builtin
		require("telescope.builtin")[builtin]()
	end
end

local palette = {
	bg = "#141415",
	inactive_bg = "#1c1c24",
	fg = "#cdcdcd",
	line = "#252530",
	string = "#e8b589",
	visual = "#333738",
	keyword = "#6e94b2",
}

local function set_telescope_highlights()
	local highlights = {
		TelescopeNormal = { fg = palette.fg, bg = palette.bg },
		TelescopeBorder = { fg = palette.bg, bg = palette.bg },
		TelescopePromptNormal = { fg = palette.fg, bg = palette.line },
		TelescopePromptBorder = { fg = palette.line, bg = palette.line },
		TelescopePromptTitle = { fg = palette.line, bg = palette.line },
		TelescopePromptPrefix = { fg = palette.keyword, bg = palette.line },
		TelescopeResultsNormal = { fg = palette.fg, bg = palette.bg },
		TelescopeResultsBorder = { fg = palette.bg, bg = palette.bg },
		TelescopeResultsTitle = { fg = palette.bg, bg = palette.bg },
		TelescopePreviewNormal = { fg = palette.fg, bg = palette.inactive_bg },
		TelescopePreviewBorder = { fg = palette.inactive_bg, bg = palette.inactive_bg },
		TelescopePreviewTitle = { fg = palette.inactive_bg, bg = palette.inactive_bg },
		TelescopeSelection = { bg = palette.visual, bold = true },
		TelescopeSelectionCaret = { fg = palette.keyword, bg = palette.visual },
		TelescopeMatching = { fg = palette.string, bold = true },
	}

	for group, value in pairs(highlights) do
		vim.api.nvim_set_hl(0, group, value)
	end
end

return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	--                        or, branch = '0.1.x',
	keys = {
		{ "<leader>ff", telescope("find_files"), desc = "telescope_find_files" },
		{ "<leader>fh", telescope("git_files"), desc = "telescope_git_files" },
		{ "<C-p>", telescope("live_grep"), desc = "telescope_live_grep" },
	},
	cmd = { "Telescope" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		-- {
		--     'nvim-telescope/telescope-fzf-native.nvim',
		--     build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
		--     lazy = true,
		-- },
	},
	opts = {
		defaults = {
			preview = { treesitter = true },
			color_devicons = true,
			sorting_strategy = "ascending",
			layout_strategy = "horizontal",
			path_display = { "smart" },
			borderchars = {
				"",
				"",
				"",
				"",
				"",
				"",
				"",
				"",
			},
			layout_config = {
				width = 0.97,
				height = 0.94,
				preview_cutoff = 40,
				horizontal = {
					prompt_position = "top",
					preview_width = 0.58,
				},
			},
			prompt_title = false,
			results_title = false,
			preview_title = false,
		},
	},
	config = function(_, opts)
		local telescope = require("telescope")
		telescope.setup(opts)
		set_telescope_highlights()

		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("justin_telescope_theme", { clear = true }),
			callback = set_telescope_highlights,
		})

		pcall(telescope.load_extension, "fzf")
	end,
}
