local function telescope(builtin)
    local params = { builtin = builtin }
    return function()
        builtin = params.builtin
        require('telescope.builtin')[builtin]()
    end
end

return {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    --                        or, branch = '0.1.x',
    keys = {
        { '<leader>ff', telescope('find_files'), desc = 'telescope_find_files' },
        { '<leader>fh', telescope('git_files'), desc = 'telescope_git_files' },
        { '<C-p>', telescope('live_grep'), desc = 'telescope_live_grep' },
    },
    cmd = { 'Telescope' },
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- {
        --     'nvim-telescope/telescope-fzf-native.nvim',
        --     build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
        --     lazy = true,
        -- },
    },
}
