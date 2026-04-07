local M = {}

M._installed = nil ---@type table<string,boolean>?
M._queries = {} ---@type table<string,boolean>

---@param update boolean?
function M.get_installed(update)
	if update then
		M._installed, M._queries = {}, {}
		for _, lang in ipairs(require("nvim-treesitter").get_installed("parsers")) do
			M._installed[lang] = true
		end
	end
	return M._installed or {}
end

---@param lang string
---@param query string
function M.have_query(lang, query)
	local key = lang .. ":" .. query
	if M._queries[key] == nil then
		M._queries[key] = vim.treesitter.query.get(lang, query) ~= nil
	end
	return M._queries[key]
end

---@param what string|number|nil
---@param query? string
---@overload fun(buf?:number):boolean
---@overload fun(ft:string):boolean
---@return boolean
function M.have(what, query)
	what = what or vim.api.nvim_get_current_buf()
	what = type(what) == "number" and vim.bo[what].filetype or what --[[@as string]]
	local lang = vim.treesitter.language.get_lang(what)
	if lang == nil or M.get_installed()[lang] == nil then
		return false
	end
	if query and not M.have_query(lang, query) then
		return false
	end
	return true
end

function M.foldexpr()
	return M.have(nil, "folds") and vim.treesitter.foldexpr() or "0"
end

function M.indentexpr()
	return M.have(nil, "indents") and require("nvim-treesitter").indentexpr() or -1
end

---@return string?
local function win_find_cl()
	local path = "C:/Program Files (x86)/Microsoft Visual Studio"
	local pattern = "*/*/VC/Tools/MSVC/*/bin/Hostx64/x64/cl.exe"
	return vim.fn.globpath(path, pattern, true, true)[1]
end

---@return boolean ok, lazyvim.util.treesitter.Health health
function M.check()
	local is_win = vim.fn.has("win32") == 1
	---@param tool string
	---@param win boolean?
	local function have(tool, win)
		return (win == nil or is_win == win) and vim.fn.executable(tool) == 1
	end

	local have_cc = vim.env.CC ~= nil or have("cc", false) or have("cl", true) or (is_win and win_find_cl() ~= nil)

	if not have_cc and is_win and vim.fn.executable("gcc") == 1 then
		vim.env.CC = "gcc"
		have_cc = true
	end

	---@class lazyvim.util.treesitter.Health: table<string,boolean>
	local ret = {
		["tree-sitter (CLI)"] = have("tree-sitter"),
		["C compiler"] = have_cc,
		tar = have("tar"),
		curl = have("curl"),
	}
	local ok = true
	for _, v in pairs(ret) do
		ok = ok and v
	end
	return ok, ret
end

---@param cb fun()
function M.build(cb)
	M.ensure_treesitter_cli(function(_, err)
		local ok, health = M.check()
		if ok then
			return cb()
		else
			local lines = { "Unmet requirements for **nvim-treesitter** `main`:" }
			local keys = vim.tbl_keys(health) ---@type string[]
			table.sort(keys)
			for _, k in pairs(keys) do
				lines[#lines + 1] = ("- %s `%s`"):format(health[k] and "✅" or "❌", k)
			end
			vim.list_extend(lines, {
				"",
				"See the requirements at [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter/tree/main?tab=readme-ov-file#requirements)",
				"Run `:checkhealth nvim-treesitter` for more information.",
			})
			if vim.fn.has("win32") == 1 and not health["C compiler"] then
				lines[#lines + 1] =
					"Install a C compiler with `winget install --id=BrechtSanders.WinLibs.POSIX.UCRT -e`"
			end
			vim.list_extend(lines, err and { "", err } or {})
			LazyVim.error(lines, { title = "LazyVim Treesitter" })
		end
	end)
end

---@param cb fun(ok:boolean, err?:string)
function M.ensure_treesitter_cli(cb)
	if vim.fn.executable("tree-sitter") == 1 then
		return cb(true)
	end

	-- try installing with mason
	if not pcall(require, "mason") then
		return cb(false, "`mason.nvim` is disabled in your config, so we cannot install it automatically.")
	end

	-- check again since we might have installed it already
	if vim.fn.executable("tree-sitter") == 1 then
		return cb(true)
	end
end

return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		-- "nvim-treesitter/nvim-treesitter-textobjects",
	},
	event = {
		"BufReadPost",
		"BufNewFile",
	},
	opts = {
		-- A list of parser names, or "all" (the four listed parsers should always be installed)
		ensure_installed = { "c", "cpp", "lua", "vim", "rust", "python", "nix", "systemverilog", "latex", "markdown" },

		-- Install parsers synchronously (only applied to `ensure_installed`)
		sync_install = false,

		-- Automatically install missing parsers when entering buffer
		-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
		auto_install = true,

		-- List of parsers to ignore installing (for "all")

		---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
		-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

		-- highlight = {
		-- 	-- `false` will disable the whole extension
		-- 	enable = true,
		-- 	disable = { "tex", "latex" },
		-- 	-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- 	-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- 	-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- 	-- Instead of true it can also be a list of languages
		-- 	additional_vim_regex_highlighting = false,
		-- },

		indent = { enable = true }, ---@type lazyvim.TSFeat
		highlight = { enable = true, disable = { "tex", "latex" } }, ---@type lazyvim.TSFeat
		-- folds = { enable = true }, ---@type lazyvim.TSFeat
		incremental_selection = {
			enable = true,
			keymaps = {
				node_incremental = "<CR>",
				node_decremental = "<BS>",
			},
		},
	},
	config = function(_, opts)
		local TS = require("nvim-treesitter")
		-- install missing parsers
		local install = vim.tbl_filter(function(lang)
			return not M.have(lang)
		end, opts.ensure_installed or {})
		if #install > 0 then
			M.build(function()
				TS.install(install, { summary = true }):await(function()
					M.get_installed(true) -- refresh the installed langs
				end)
			end)
		end

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

		-- vim.api.nvim_create_autocmd("FileType", {
		-- 	group = vim.api.nvim_create_augroup("lazyvim_treesitter", { clear = true }),
		-- 	callback = function(ev)
		-- 		local ft, lang = ev.match, vim.treesitter.language.get_lang(ev.match)
		-- 		if not M.have(ft) then
		-- 			return
		-- 		end
		--
		-- 		---@param feat string
		-- 		---@param query string
		-- 		local function enabled(feat, query)
		-- 			local f = opts[feat] or {} ---@type lazyvim.TSFeat
		-- 			return f.enable ~= false
		-- 				and not (type(f.disable) == "table" and vim.tbl_contains(f.disable, lang))
		-- 				and M.have(ft, query)
		-- 		end
		--
		-- 		-- highlighting
		-- 		if enabled("highlight", "highlights") then
		-- 			pcall(vim.treesitter.start, ev.buf)
		-- 		end
		--
		-- 		-- indents
		-- 		if enabled("indent", "indents") then
		-- 			-- LazyVim.set_default("indentexpr", "v:lua.M.indentexpr()")
		-- 			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		-- 		end
		-- 	end,
		-- })
	end,
}
