vim.keymap.set("n", "<leader>r", "<Cmd>0,$w !perl<CR>")
vim.keymap.set("v", "<leader>r", ":w !perl<CR>")

vim.keymap.set("n", "<leader>f", "<Cmd>0,$!perl<CR>")
vim.keymap.set("v", "<leader>f", ":!perl<CR>")
