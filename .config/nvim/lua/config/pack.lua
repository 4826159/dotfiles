local plugins = {
    { src = 'https://github.com/folke/tokyonight.nvim' },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" }, -- For :TSInstall
    { src = 'https://github.com/nvim-lua/plenary.nvim' },
    { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
    { src = 'https://github.com/nvim-lualine/lualine.nvim' },
    { src = 'https://github.com/nvim-telescope/telescope.nvim' },
    { src = 'https://github.com/folke/which-key.nvim' },
    { src = 'https://github.com/folke/todo-comments.nvim' },
    { src = 'https://github.com/tpope/vim-fugitive' },
    { src = 'https://github.com/lewis6991/gitsigns.nvim' },
    { src = 'https://github.com/tpope/vim-sleuth.git' },
    { src = 'https://github.com/mason-org/mason.nvim.git' },
}

local local_plugins = nil
local ok, mod = pcall(require, 'local_plugins')
if ok then
    local_plugins = type(mod) == 'function' and mod() or mod
    if type(local_plugins) == 'table' then
        local specs = local_plugins.specs or local_plugins
        if type(specs) == 'table' then
            vim.list_extend(plugins, specs)
        end
    end
end

vim.pack.add(plugins, { confirm = false, load = true })

if type(local_plugins) == 'table' and type(local_plugins.setup) == 'function' then
    local_plugins.setup()
end
