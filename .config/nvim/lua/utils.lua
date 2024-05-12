local Hydra = require'hydra'
M = {}

local function createHydra(tbl)
    local heads = {
            { ']', '<cmd>' .. tbl.next .. '<cr>'},
            { '[', '<cmd>' .. tbl.prev .. '<cr>', { desc = '←/→ ' .. tbl.name}},
    }
    if tbl.del then
        table.insert(heads, { 'd', '<cmd>' .. tbl.del .. '<cr>', { desc = "delete" }})
    end
    vim.list_extend(heads, {
            { '<Esc>', nil, { exit = true }},
            { 'q', nil, { exit = true, desc = "exit" }},
    })
    local hydra = Hydra({
        name = tbl.name,
        mode = "n",
        heads = heads
    })
    vim.keymap.set('n', '[' .. tbl.key, function()
        vim.cmd("silent! " .. tbl.prev)
        hydra:activate()
    end)
    vim.keymap.set('n', ']' .. tbl.key, function()
        vim.cmd("silent! " .. tbl.next)
        hydra:activate()
    end)
end

M.createHydra = createHydra
return M
