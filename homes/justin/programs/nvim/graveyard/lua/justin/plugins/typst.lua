return {
	{
		"kaarmu/typst.vim",
		ft = { "typst" },
	},
	{
		"chomosuke/typst-preview.nvim",
		ft = { "typst" },
		version = "1.*",
		opts = {
			dependencies_bin = {
				tinymist = "tinymist",
				websocat = "websocat",
			},
			invert_colors = "auto",
		},
		config = function(_, opts)
			require("typst-preview").setup(opts)

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "typst",
				callback = function(args)
					local map = function(lhs, rhs, desc)
						vim.keymap.set("n", lhs, rhs, { buffer = args.buf, desc = desc })
					end

					map("<leader>tp", "<cmd>TypstPreview<CR>", "Typst Preview")
					map("<leader>tP", "<cmd>TypstPreview slide<CR>", "Typst Preview Slides")
					map("<leader>tt", "<cmd>TypstPreviewToggle<CR>", "Typst Preview Toggle")
					map("<leader>tq", "<cmd>TypstPreviewStop<CR>", "Typst Preview Stop")
				end,
			})
		end,
	},
}
