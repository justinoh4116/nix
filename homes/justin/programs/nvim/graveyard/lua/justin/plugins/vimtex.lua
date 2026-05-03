return {
	"lervag/vimtex",
	event = { "BufReadPre", "BufNewFile" },
	init = function()
		vim.g.tex_flavor = "latex"
		vim.g.vimtex_view_method = "zathura"
		vim.g.vimtex_quickfix_mode = 0
		vim.opt.conceallevel = 0
		vim.g.vimtex_fold_enabled = 0
		vim.env.VIMTEX_OUTPUT_DIRECTORY = "../build/main"
		-- vim.g.tex_conceal='abdmg'
	end,
}
