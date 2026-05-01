local ok, which_key = pcall(require, 'which-key')
if not ok then
    return
end

which_key.setup({
    delay = 150,
    icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
            Up = '<Up> ',
            Down = '<Down> ',
            Left = '<Left> ',
            Right = '<Right> ',
            C = '<C-...> ',
            M = '<M-...> ',
            D = '<D-...> ',
            S = '<S-...> ',
            CR = '<CR> ',
            Esc = '<Esc> ',
            Space = '<Space> ',
            Tab = '<Tab> ',
        },
    },
    spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>g', group = '[G]it', mode = { 'n', 'v' } },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>w', group = '[W]orkspace' },
    },
})
