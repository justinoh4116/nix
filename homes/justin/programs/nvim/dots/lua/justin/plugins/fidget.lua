return {
    'j-hui/fidget.nvim',
    tag = 'v1.0.0',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
        progress = {
            display = {
                progress_icon = {
                    pattern = "pipe",
                },
            },
        },
    },
}
