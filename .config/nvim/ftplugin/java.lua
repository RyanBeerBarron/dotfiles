vim.opt["path"] = vim.opt["path"] + "/home/ryan/.config/maven/repository"

vim.cmd.inoreabbrev({"sout", "System.out.println"})
vim.cmd.inoreabbrev({"psvm", "public static void main(String[] args){\n\n}<ESC>kI\t"})
vim.keymap.set("n", "<M-m>", "<Cmd>!mvn clean compile<CR>")
