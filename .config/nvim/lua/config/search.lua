local ok, telescope = pcall(require, 'telescope')
if not ok then
    return
end

telescope.setup({})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [w]ord' })
vim.keymap.set('n', '<leader>sW', function()
    builtin.grep_string({ word_match = '-w' })
end, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sGs', builtin.git_status, { desc = '[S]earch [G]it [S]tatus' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', 'gE', vim.diagnostic.open_float, { desc = 'Diagnostic Float' })

vim.keymap.set('n', '<leader>/', function()
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
        winblend = 10,
        previewer = false,
    }))
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>s/', function()
    builtin.live_grep({
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
    })
end, { desc = '[S]earch [/] in Open Files' })

vim.keymap.set('n', '<leader>sn', function()
    builtin.find_files({ cwd = vim.fn.stdpath('config') })
end, { desc = '[S]earch [N]eovim files' })

-- Custom picker for git diff between commits
local function git_diff_files(commit1, commit2)
    commit1 = commit1 or 'HEAD~1'
    commit2 = commit2 or 'HEAD'

    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local previewers = require('telescope.previewers')
    local conf = require('telescope.config').values
    local action_state = require('telescope.actions.state')
    local actions = require('telescope.actions')

    -- Get the list of changed files
    local cmd = { 'git', 'diff', '--name-only', commit1 .. '..' .. commit2 }
    local output = vim.fn.systemlist(cmd)

    -- Filter out empty lines
    local files = vim.tbl_filter(function(line)
        return line ~= ''
    end, output)

    if #files == 0 then
        vim.notify('No changed files between ' .. commit1 .. ' and ' .. commit2, vim.log.levels.INFO)
        return
    end

    -- Custom previewer for git diff
    local diff_previewer = previewers.new_termopen_previewer({
        get_command = function(entry)
            return { 'git', 'diff', commit1 .. '^', '--', entry.value }
        end,
    })

    pickers.new({}, {
        prompt_title = 'Git Diff: ' .. commit1 .. '..' .. commit2,
        finder = finders.new_table({
            results = files,
        }),
        previewer = diff_previewer,
        sorter = conf.file_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                if selection then
                    vim.cmd('edit ' .. selection.value)
                end
            end)
            return true
        end,
    }):find()
end

-- Keymap for git diff picker (default HEAD~1..HEAD)
vim.keymap.set('n', '<leader>sGd', function()
    git_diff_files('HEAD~1', 'HEAD')
end, { desc = '[S]earch [G]it [D]iff HEAD^' })

-- Command to call git diff picker with custom commit arguments
vim.api.nvim_create_user_command('GitDiffFiles', function(opts)
    local commit1 = opts.args and opts.args:match('([^%s]+)') or 'HEAD~1'
    local commit2 = opts.args and opts.args:match('[^%s]+%s+([^%s]+)') or 'HEAD'
    git_diff_files(commit1, commit2)
end, {
    nargs = '*',
    desc = 'Search git diff files between two commits (default: HEAD~1 HEAD)',
})
