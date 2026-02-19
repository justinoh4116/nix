return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			-- Conform will run multiple formatters sequentially
			python = { "isort", "ruff_format", "black" },
			-- Use a sub-list to run only the first available formatter
			javascript = { "prettierd", "prettier" },
			nix = { "alejandra" },
			sv = { "verible" },
			v = { "verible" },
			cpp = { "clang-format" },
			h = { "clang-format" },
			c = { "clang-format" },
		},
		default_format_opts = {
			lsp_format = "fallback",
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
