if vim.fn.executable("jupynium") == 1 then -- only active when jupynium is available
	return {
		"kiyoon/jupynium.nvim",
		-- build = "pip3 install --user .",
		build = "uv pip install . ", ----python=$HOME/.virtualenvs/jupynium/bin/python",
		-- build = "conda run --no-capture-output -n jupynium pip install .",
		-- ft = { "ipynb", "ju.py" },
		config = function()
			require("jupynium.nvim").setup({
				-- Configuration here, or leave empty to use defaults
				python_host = "python",
			})
		end,
	}
end
