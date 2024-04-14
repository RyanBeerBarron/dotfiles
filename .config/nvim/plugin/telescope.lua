vim.keymap.set("n", "<C-g><C-g>", "<cmd>Telescope live_grep<cr>")
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
vim.keymap.set("n", "<leader>fc", "<cmd>Telescope commands<cr>")
vim.keymap.set("n", "<leader>fq", "<cmd>Telescope quickfix<cr>")
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope registers<cr>")

vim.keymap.set("n", "<leader>lr", "<cmd>Telescope lsp_references<cr>")
vim.keymap.set("n", "<leader>li", "<cmd>Telescope lsp_incoming_calls<cr>")
vim.keymap.set("n", "<leader>lo", "<cmd>Telescope lsp_outgoing_calls<cr>")

local function filenameFirst(_, path)
	local tail = vim.fs.basename(path)
	local parent = vim.fs.dirname(path)
	if parent == "." then return tail end
	return string.format("%s\t%s", tail, parent),{{{ 1, #tail }, "Constant" }}
end
require'telescope'.setup({
    defaults = {
        mappings = {
            i = {
                ["<C-r>"] = "send_to_qflist",
            }
        },
        vimgrep_arguments = {
            "git",
            "grep",
            "-I",
            "-H",
            "--extended-regexp",
            "--ignore-case",
            "--column",
            "--recursive",
            "--color=never",
            "--line-number"
        }
    },
    pickers = {
        git_files = {
            path_display = filenameFirst
        },
        find_files = {
            path_display = filenameFirst
        },
        live_grep = {
            path_display = filenameFirst
        },
    }
})
