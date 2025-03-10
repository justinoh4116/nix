-- center screen when using ctrl d and u vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
-- vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
-- vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

-- center screen when navigating search results
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Visual --
-- Stay in indent mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- move selected lines up and down
vim.keymap.set("v", "<A-k>", ":m .-2<CR>==", { silent = true })
vim.keymap.set("v", "<A-j>", ":m .+1<CR>==", { silent = true })

-- move text in visual block
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv", { silent = true })
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv", { silent = true })
vim.keymap.set("x", "<A-j>", ":move '>+1<CR>gv-gv", { silent = true })
vim.keymap.set("x", "<A-k>", ":move '<-2<CR>gv-gv", { silent = true })

-- clear search highlights
vim.keymap.set("n", "<leader>sc", "<cmd>nohl<CR>")

vim.keymap.set("n", "x", "\"_x")

vim.keymap.set("n", "J", "mzJ`z")

-- <leader>y goes to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- shift D does not cut
vim.keymap.set("n", "D", "\"_d")
vim.keymap.set("v", "D", "\"_d")


-- ctrl + backspace
vim.keymap.set("i", "<C-BS>", "<Esc>cvb", { silent = true })

-- yanking does not move the cursor to the start of the selection
vim.keymap.set("v", "y", "mxy`x")

vim.keymap.set("n", "H", "^")
vim.keymap.set("n", "L", "$")

vim.keymap.set("n", "<C-S-h>", "<C-w>h", { silent = true })
vim.keymap.set("n", "<C-S-j>", "<C-w>j", { silent = true })
vim.keymap.set("n", "<C-S-k>", "<C-w>k", { silent = true })
vim.keymap.set("n", "<C-S-l>", "<C-w>l", { silent = true })

vim.keymap.set({"n", "o", "x"}, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
vim.keymap.set({"n", "o", "x"}, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
vim.keymap.set({"n", "o", "x"}, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
vim.keymap.set({"n", "o", "x"}, "ge", "<cmd>lua require('spider').motion('ge')<CR>", { desc = "Spider-ge" })
