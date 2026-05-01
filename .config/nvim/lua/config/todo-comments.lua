local configured = false

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
    group = vim.api.nvim_create_augroup('config-todo-comments', { clear = true }),
    pattern = { '*.c', '*.h', '*.py' },
    callback = function()
        if configured then
            return
        end

        require('todo-comments').setup({
            signs = false,
        })
        configured = true
    end,
})
