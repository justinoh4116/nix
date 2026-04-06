return {
	"OXY2DEV/markview.nvim",
	lazy = false,

	-- Completion for `blink.cmp`
	dependencies = { "saghen/blink.cmp" },

	config = function()
		require("markview").setup({
			markdown = {
				headings = {
					heading_1 = { icon_hl = "@markup.link", icon = "[%d] " },
					heading_2 = { icon_hl = "@markup.link", icon = "[%d.%d] " },
					heading_3 = { icon_hl = "@markup.link", icon = "[%d.%d.%d] " },
				},
			},
		})
		vim.api.nvim_set_keymap(
			"n",
			"<leader>mm",
			"<CMD>Markview<CR>",
			{ desc = "Toggles `markview` previews globally." }
		)
		vim.api.nvim_set_keymap(
			"n",
			"<leader>ms",
			"<CMD>Markview splitToggle<CR>",
			{ desc = "Toggles `splitview` for current buffer." }
		)
	end,
}
