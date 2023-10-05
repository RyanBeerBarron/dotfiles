vim.keymap.set('i', '<Tab>', function()
    return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
end, {expr = true})

vim.keymap.set('i', '<S-tab>', function()
    return vim.fn.pumvisible() == 1 and "<C-p>" or "<BS>"
end, {expr = true})
