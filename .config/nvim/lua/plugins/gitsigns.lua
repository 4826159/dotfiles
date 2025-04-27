-- From kickstart.nvim
return {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'tpope/vim-fugitive' },
    opts = {
        signs = {
            add = { text = '+' },
            change = { text = '~' },
            delete = { text = '_' },
            topdelete = { text = '‾' },
            changedelete = { text = '~' },
        },
    },
    config = function()
        require("gitsigns").setup {
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                local opts = { buffer = bufnr, noremap = true, silent = true }
                local vopts = { buffer = bufnr, noremap = true, silent = true, expr = false }

                -- Hunk navigation using new `nav_hunk`
                vim.keymap.set("n", "]g", function() gs.nav_hunk("next") end, opts)
                vim.keymap.set("n", "[g", function() gs.nav_hunk("prev") end, opts)

                -- Git actions
                -- vim.tbl_extend adds desc to the opts
                vim.keymap.set("n", "<leader>gbb", gs.blame_line, vim.tbl_extend("force", opts, { desc = "Blame line" }))
                vim.keymap.set("n", "<leader>gq", gs.setqflist, vim.tbl_extend("force", opts, { desc = "Hunks to quickfix" }))
                vim.keymap.set("n", "<leader>gQ", function() gs.setqflist('all') end, vim.tbl_extend("force", opts, { desc = "All hunks to quickfix" }))
                vim.keymap.set("n", "<leader>gr", gs.reset_hunk, vim.tbl_extend("force", opts, { desc = "Reset hunk" }))
                vim.keymap.set("v", "<leader>gr", function()
                    gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") }
                end, vim.tbl_extend("force", vopts, { desc = "Reset hunk (range)" }))
                vim.keymap.set("n", "<leader>gdd", gs.diffthis, vim.tbl_extend("force", opts, { desc = "Diff against index" }))
                vim.keymap.set("n", "<leader>gd1", function()
                    gs.diffthis("~1")
                end, vim.tbl_extend("force", opts, { desc = "Diff against previous commit" }))

                -- Blame checkout for the commit at the line
                vim.keymap.set("n", "<leader>gcb", function()
                    local commit = require("gitsigns").blame_line { full = true }
                    if commit and commit.commit then
                        vim.cmd("Git checkout " .. commit.commit)
                    end
                end, { desc = "Checkout commit from blame", noremap = true, silent = true })

                -- Blame checkout for the commit's parent at the line
                vim.keymap.set("n", "<leader>gcB", function()
                    local commit = require("gitsigns").blame_line { full = true }
                    if commit and commit.commit then
                        vim.cmd("Git checkout " .. commit.commit .. "^")
                    end
                end, { desc = "Checkout parent of commit from blame", noremap = true, silent = true })

                -- Show log/diff of the current commit
                vim.keymap.set("n", "<leader>gl", function()
                    vim.cmd("Git log -p -1")
                end, { desc = "Show log/diff of current commit", noremap = true, silent = true })

                -- Show blame for the current line (not working, uses a floating window?)
                vim.keymap.set("n", "<leader>gbl", function()
                    local commit = require("gitsigns").blame_line { full = false }
                    if commit and commit.commit then
                        vim.cmd("Git log -p -1 " .. commit.commit)
                    end
                end, { desc = "Show blame commit in Fugitive", noremap = true, silent = true })
            end
        }
    end
}
