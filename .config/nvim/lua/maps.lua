require("commands")
vim.g.mapleader = " "
vim.keymap.set("i", "<TAB>", "<C-n>")
vim.keymap.set("n", "<C-E>", vim.cmd.Ex)
vim.keymap.set("n", "<leader>po", "<Cmd>Options<CR>") 
vim.keymap.set("n", "<leader>pc", "<Cmd>Commands<CR>") 
vim.keymap.set("n", "<leader>pm", "<Cmd>Maps<CR>") 
vim.keymap.set("n", "<leader>cc", "<Cmd>Config<CR>") 
vim.keymap.set("n", "<S-Tab>", "<C-O>")
vim.keymap.set("n", "<C-6>", "<C-^>")

vim.keymap.set("n", "<leader>tc", "<Cmd>tabclose<CR>")
vim.keymap.set("n", "<leader>tn", "<Cmd>tabnew<CR>")

vim.keymap.set("n", "<leader>vc", "<Cmd>tabclose<CR>")
vim.keymap.set("n", "<leader>vn", "<Cmd>tabnew<CR>")

vim.keymap.set("n", "<leader>w_", "<Cmd>vertical resize<CR>")

vim.keymap.set("n", "<leader>f", "<Cmd>execute \"find\" expand(\"<cword>\")<CR>") 

vim.keymap.set("n", "<leader>:", "<Cmd>!tmux command<CR><CR>")

vim.keymap.set("v", "<TAB>", ">", {noremap = true})
vim.keymap.set("v", "<S-TAB>", "<", {noremap = true})

-- TODO:Replace the path with a relative path / variable
-- vim.keymap.set("n", ",build", "<Cmd>-1read /home/ryan/scripts/tool.c.template<CR>", {noremap = true})

vim.keymap.set("n", "<M-m>", "<Cmd>make<CR>")
vim.keymap.set("n", "<F5>", "<Cmd>cnext<CR>")
vim.keymap.set("n", "<F4>", "<Cmd>cprev<CR>")
