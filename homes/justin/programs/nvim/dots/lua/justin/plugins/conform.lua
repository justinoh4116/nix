return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			-- Conform will run multiple formatters sequentially
			python = { "isort", { "ruff_format", "black" } },
			-- Use a sub-list to run only the first available formatter
			javascript = { { "prettierd", "prettier" } },
			nix = { "alejandra" },
		},
	},
	keys = {
		{
			"<F3>",
			function()
				require("conform").format()
			end,
		},
	},
}
