local M = {}

---@type table<string, string[]>
local color_tbl = {
    light = {
        'PaperColor',
        'kanagawa-lotus',
        'onenord',
        'catppuccin-latte',
        'gruvbox',
        'github_light',
        'tokyonight',
    },
    dark = {
        'kanagawa-wave',
        'vim-monokai-tasty',
        'gruvbox',
        'catppuccin-macchiato',
        'nordic',
        'tokyonight',
        'onenord',
        'moonfly',
        'github_dark',
    }
}

local function get_index(color_name, background)
    local list = color_tbl[background]
    for idx, val in ipairs(list) do
        if val == color_name then
            return idx
        end
    end
    return nil
end
local bg = vim.o.background or "dark"
---@class color_idx
---@field background string
---@field index integer
local current = {
    background = bg,
    index = get_index(vim.g.colors_name, bg) or 6
}

local function set_colorscheme(background, color_name)
    current.background = background
    current.index = get_index(color_name, background) or 1
    vim.o.background=background
    vim.cmd("colorscheme " .. color_tbl[background][current.index])
end
local function color_next()
    if current.index >= vim.tbl_count(color_tbl[current.background]) then
        current.index = 1
        current.background = current.background == 'dark' and 'light' or 'dark'
    else
        current.index = current.index + 1
    end
    vim.o.background=current.background
    vim.cmd("colorscheme " .. color_tbl[current.background][current.index])
end
local function color_prev()
    if current.index <= 1 then
        current.background = current.background == 'dark' and 'light' or 'dark'
        current.index = vim.tbl_count(color_tbl[current.background])
    else
        current.index = current.index - 1
    end
    vim.o.background=current.background
    vim.cmd("colorscheme " .. color_tbl[current.background][current.index])
end

M.set_colorscheme = set_colorscheme
M.color_next = color_next
M.color_prev = color_prev

return M;
