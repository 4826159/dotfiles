local ok, mason = pcall(require, 'mason')
if not ok then
    error()
    return
end

mason.setup()

