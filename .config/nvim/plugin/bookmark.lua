---@type string
local keys = "asdf"

local function bookmark(file, c)
    vim.g["BOOKMARK_" .. string.upper(c)] = file
end

local function open_bookmark(c)
    local file = vim.g["BOOKMARK_" .. string.upper(c)]
    if file == nil then
        print("Error, bookmark for " .. c .. " is not defined")
        return
    end
    vim.cmd("buffer " .. file)
end

local function list_bookmarks()
    for idx = 1, #keys do
        local c = keys:sub(idx, idx)
        local fullpath = vim.g["BOOKMARK_" .. string.upper(c)]
        local filename = vim.fn.fnamemodify(fullpath, ":t")
        print(c .. ": " .. filename)
    end
end

local function tab_bookmarks()
    for idx = 1, #keys do
        local c = keys:sub(idx, idx)
        local fullpath = vim.g["BOOKMARK_" .. string.upper(c)]
        vim.cmd("tabnew " .. fullpath)
    end
end

vim.api.nvim_create_user_command("ListBookmarks", list_bookmarks, {})
vim.api.nvim_create_user_command("TabBookmarks", tab_bookmarks, {})
for idx = 1, #keys do
    local c = keys:sub(idx, idx)
    vim.keymap.set("n", "<M-" .. c .. ">", function() open_bookmark(c) end, {})
    vim.keymap.set("n", "<M-C-" .. c .. ">", function() bookmark(vim.fn.expand("%:p"), c) end, {})
end

vim.keymap.set("n", "<C-b>l", "<cmd>ListBookmarks<cr>", {})

local bookmarks = vim.api.nvim_create_augroup("Bookmarks", {
    clear = true
})
vim.api.nvim_create_autocmd("VimEnter", {
    group = bookmarks,
    pattern = "*",
    callback = function()
        for idx = 1, #keys do
            local c = keys:sub(idx, idx)
            local fullpath = vim.g["BOOKMARK_" .. string.upper(c)]
            local bufnr = vim.fn.bufadd(fullpath)
            vim.fn.bufload(bufnr)
            vim.fn.setbufvar(bufnr, "&buflisted", 1)
        end
    end
})
