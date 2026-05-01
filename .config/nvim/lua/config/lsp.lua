vim.opt.completeopt = { 'menuone', 'noselect', 'popup' }

vim.keymap.set('i', '<C-Space>', function()
    vim.lsp.completion.get()
end, { desc = 'Trigger LSP completion' })

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('config-lsp-attach', { clear = true }),
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        local telescope_ok, builtin = pcall(require, 'telescope.builtin')

        local map = function(keys, func, desc, mode)
            vim.keymap.set(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        local pick = function(telescope_fn, lsp_fn)
            return telescope_ok and builtin[telescope_fn] or lsp_fn
        end

        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map('gd', pick('lsp_definitions', vim.lsp.buf.definition), '[G]oto [D]efinition')
        map('gr', pick('lsp_references', vim.lsp.buf.references), '[G]oto [R]eferences')
        map('gI', pick('lsp_implementations', vim.lsp.buf.implementation), '[G]oto [I]mplementation')
        map('<leader>D', pick('lsp_type_definitions', vim.lsp.buf.type_definition), 'Type [D]efinition')
        map('<leader>ds', pick('lsp_document_symbols', vim.lsp.buf.document_symbol), '[D]ocument [S]ymbols')
        map('<leader>ws', pick('lsp_dynamic_workspace_symbols', vim.lsp.buf.workspace_symbol), '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
        map('<leader>cf', vim.lsp.buf.format, '[C]ode [F]ormat', { 'n', 'x' })
        map('<leader>ci', pick('lsp_incoming_calls', vim.lsp.buf.incoming_calls), '[C]alls [I]ncoming')
        map('<leader>co', pick('lsp_outgoing_calls', vim.lsp.buf.outgoing_calls), '[C]alls [O]utgoing')

        if client and client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
        end

        if client and client:supports_method('textDocument/documentHighlight') then
            local group = vim.api.nvim_create_augroup('config-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                group = group,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                group = group,
                callback = vim.lsp.buf.clear_references,
            })
        end

        if client and client:supports_method('textDocument/inlayHint') then
            map('<leader>th', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
        end
    end,
})

local function enable_if_available(name)
    local ok, config = pcall(function()
        return vim.lsp.config[name]
    end)
    if not ok or type(config) ~= 'table' then
        return
    end

    local executable = type(config.cmd) == 'table' and config.cmd[1] or nil
    if executable and vim.fn.executable(executable) == 0 then
        return
    end

    vim.lsp.enable(name)
end

enable_if_available('lua_ls')
enable_if_available('clangd')
