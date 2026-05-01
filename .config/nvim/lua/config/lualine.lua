local ok, lualine = pcall(require, 'lualine')
if not ok then
    error()
    return
end

lualine.setup()
