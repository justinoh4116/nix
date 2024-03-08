return {
    'stevearc/oil.nvim',
    config = true,
    keys = {
        { '<leader>oi', '<cmd>Oil<cr>', desc = 'Oil file manager' },
        { '-', '<cmd>Oil<cr>', desc = 'open parent directory in Oil' },
    },
    cmd = 'Oil',
}
