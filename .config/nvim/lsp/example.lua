-- Copy this file to lsp/<server-name>.lua, replace the values, then enable it
-- from lua/config/lsp.lua with enable_if_available('<server-name>').
return {
    cmd = { 'example-language-server', '--stdio' },
    filetypes = { 'example' },
    root_markers = { 'example.toml', '.git' },
    settings = {
        example = {},
    },
}
