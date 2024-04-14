local Hydra = require'hydra'
local colors = require'colors'
local utils = require'utils'

Hydra({
    name = "Side scroll",
    mode = "n",
    body = "z",
    heads = {
        { 'h', 'zh' },
        { 'j', '<C-e>' },
        { 'k', '<C-y>' },
        { 'l', 'zl', { desc = '←/→' }},
        { 'H', 'zH' },
        { 'L', 'zL', { desc = 'half screen ←/→' }},
        { 'q', nil, { exit = true, desc = "exit" }},
    }
})

Hydra({
    name = "Window resize",
    mode = "n",
    body = "<C-w>",
    heads = {
        { '+', '<c-w>+' },
        { '-', '<c-w>-' },
        { '>', '<c-w>>' },
        { '<', '<c-w><' },
        { 'q', nil, { exit = true, desc = "exit" }},
    }
})

utils.createHydra( { name = "Arg", key = "a", next = "next", prev = "prev", del = "argdelete" } )
utils.createHydra( { name = "Buffer", key = "b", next = "bnext", prev = "bprev", del = "bdelete" } )
utils.createHydra( { name = "Tabs", key = "t", next = "tabnext", prev = "tabprev", del = "tabclose" } )
utils.createHydra( { name = "Quickfix", key = "q", next = "cnext", prev = "cprev" } )
utils.createHydra( { name = "Location", key = "l", next = "lnext", prev = "lprev" } )
utils.createHydra( { name = "Tags", key = "g", next = "tag", prev = "pop" } )
utils.createHydra( { name = "Marks", key = "m", next = "lua require'marks'.next()", prev = "lua require'marks'.prev()", del = "lua require'marks'.delete_line()"})
utils.createHydra( { name = "Colorscheme", key = "c", next = "Colornext", prev = "Colorprev" })

vim.api.nvim_create_user_command("Colornext", colors.color_next, {})
vim.api.nvim_create_user_command("Colorprev", colors.color_prev, {})
