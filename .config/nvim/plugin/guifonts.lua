local utils = require'utils'
---@class Font
---@field name string
---@field size integer

---@type Font
local iosevka = {
    name = "IosevkaTerm Nerd Font",
    size = 14,
}
---@type Font
local caskaydia = {
    name = "CaskaydiaCove Nerd Font",
    size = 14,
}

---@type Font
local jetbrainsmono  = {
    name = "JetBrainsMono Nerd Font",
    size = 14,
}

---@type Font
local profont = {
    name = "ProFont IIx Nerd Font",
    size = 10,
}
---@type Font
local firacode = {
    name = "FiraCode Nerd Font",
    size = 16,
}

---@type Font
---@type Font[]
local fonts = {
    iosevka,
    caskaydia,
    jetbrainsmono,
    profont,
}

---@type integer
local font_idx = 1

local function set_font(index)
    local font = fonts[index]
    vim.o.guifont = font.name .. ":h" .. font.size
end

local function next_font()
    if font_idx >= vim.tbl_count(fonts) then
        font_idx = 1
    else
        font_idx = font_idx + 1
    end
    set_font(font_idx)
end

local function prev_font()
    if font_idx <= 1 then
        font_idx = vim.tbl_count(fonts)
    else
        font_idx = font_idx - 1
    end
    set_font(font_idx)

end

vim.api.nvim_create_user_command("GuifontNext", next_font, {})
vim.api.nvim_create_user_command("GuifontPrev", prev_font, {})

utils.createHydra( { name = "Fonts", key = "f", next = "GuifontNext", prev = "GuifontPrev" })
