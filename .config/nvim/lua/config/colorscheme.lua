local ok = pcall(vim.cmd.colorscheme, 'tokyonight')
if not ok then
    vim.cmd.colorscheme('habamax')
end
