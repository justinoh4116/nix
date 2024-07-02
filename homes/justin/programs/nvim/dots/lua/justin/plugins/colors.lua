-- Sets colors to line numbers Above, Current and Below  in this order
function LineNumberColors()
  vim.api.nvim_set_hl(0, 'LineNrAbove', { fg='#6C6F85' })
  vim.api.nvim_set_hl(0, 'LineNr', { fg='#6C6F85', bold=true })
  vim.api.nvim_set_hl(0, 'LineNrBelow', { fg='#6C6F85' })
end

return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
        vim.cmd[[colorscheme tokyonight]]
        LineNumberColors()
    end,
}
