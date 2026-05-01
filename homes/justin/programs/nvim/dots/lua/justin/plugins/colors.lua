-- Sets colors to line numbers Above, Current and Below  in this order
function LineNumberColors()
	vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#6C6F85" })
	vim.api.nvim_set_hl(0, "LineNr", { fg = "#6C6F85", bold = true })
	vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#6C6F85" })
end

return {
	-- "folke/tokyonight.nvim",
	--  = false,
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
		"vague-theme/vague.nvim",
		priority = 1000,
		name = "vague",
		opts = {
			transparent = false,
			bold = true,
			italic = true,
			colors = {
				bg = "#141415",
				inactiveBg = "#1c1c24",
				fg = "#cdcdcd",
				floatBorder = "#878787",
				line = "#252530",
				comment = "#606079",
				builtin = "#b4d4cf",
				func = "#c48282",
				string = "#e8b589",
				number = "#e0a363",
				property = "#c3c3d5",
				constant = "#aeaed1",
				parameter = "#bb9dbd",
				visual = "#333738",
				error = "#d8647e",
				warning = "#f3be7c",
				hint = "#7e98e8",
				operator = "#90a0b5",
				keyword = "#6e94b2",
				type = "#9bb4bc",
				search = "#405065",
				plus = "#7fa563",
				delta = "#f3be7c",
			},
		},
		config = function(_, opts)
			require("vague").setup(opts)
			vim.cmd([[colorscheme vague]])
			LineNumberColors()
		end,
	},
}
