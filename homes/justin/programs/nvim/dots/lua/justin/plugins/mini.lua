return {
	"nvim-mini/mini.nvim",
	version = false,
	config = function()
		require("mini.indentscope").setup()
		-- require("mini.pairs").setup()
		require("mini.keymap").setup()
		require("mini.ai").setup()
		require("mini.surround").setup()
	end,
}
