
vim.keymap.set("n", "<leader>r", "<Cmd>0,$w !bash<CR>")
vim.keymap.set("v", "<leader>r", ":w !bash<CR>")

vim.keymap.set("n", "<leader>f", "<Cmd>0,$!bash<CR>")
vim.keymap.set("v", "<leader>f", ":!bash<CR>")
