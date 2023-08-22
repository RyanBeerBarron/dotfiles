local config_path = vim.fn.stdpath('config')

-- COMMANDS
vim.cmd.colorscheme("retrobox")
vim.api.nvim_create_user_command("Config", "edit " .. config_path .. "/init.lua", {})

-- MAPPING
vim.g.mapleader = " "
vim.keymap.set("n", "<C-e>", vim.cmd.Ex)
vim.keymap.set("n", "<leader>cc", "<Cmd>Config<CR>") 

vim.keymap.set("n", "<leader>tc", "<Cmd>tabclose<CR>")
vim.keymap.set("n", "<leader>tn", "<Cmd>tabnew<CR>")

vim.keymap.set("n", "<leader>f", "<Cmd>execute \"find\" expand(\"<cword>\")<CR>") 
vim.keymap.set("n", "<leader>:", "<Cmd>!tmux command<CR><CR>")

vim.keymap.set("n", "<M-m>", "<Cmd>make<CR>")
vim.keymap.set("n", "<F5>", "<Cmd>cnext<CR>")
vim.keymap.set("n", "<F4>", "<Cmd>cprev<CR>")

vim.keymap.set("i", "(", "()<Left>", {noremap = true})
vim.keymap.set("i", "{", "{}<Left>", {noremap = true})
vim.keymap.set("i", "{<cr>", "{<cr>}<ESC>O", {noremap = true})
vim.keymap.set("i", "[", "[]<Left>", {noremap = true})
vim.keymap.set("i", "'", "''<Left>", {noremap = true})
vim.keymap.set("i", "\"", "\"\"<Left>", {noremap = true})


-- TODO: Replace the path with a relative path / variable
-- vim.keymap.set("n", ",build", "<Cmd>-1read /home/ryan/scripts/tool.c.template<CR>", {noremap = true})

-- OPTIONS
options = {
    autowrite = true,
    backupext = ".bak",
    concealcursor = "",
    conceallevel = 0,
    cursorcolumn = true,
    cursorline = true,
    expandtab = true,
    foldclose = "all",
    foldcolumn = "2",
    foldopen = "all",
    hlsearch = true,
    incsearch = true,
    number = true,
    scrolloff = 8,
    shiftwidth = 4,
    smartindent = true,
    softtabstop = 4,
    tabstop = 4,
    tildeop = true,
    wrap = false,
    guifont = "IosevkaTerm Nerd Font:h16",
    -- guifont = "CaskaydiaCove Nerd Font:h16",
}

for key,val in pairs(options) do
    vim.opt[key] = val
end

appends = {
    path = "**",
    wildignore = "*.class",
    wildignore = "**/target/**"
}

for key,val in pairs(appends) do
    vim.opt[key] = vim.opt[key] + val
end

netrw_options = { 
    banner = 0,
    liststyle = 3
}
