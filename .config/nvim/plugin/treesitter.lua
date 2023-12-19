require 'nvim-treesitter.configs'.setup({
    sync_install = false,
    highlight = {
        enable = true,
        disable = { "vim" },
        additional_vim_regex_highlighting = false
    },

    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn", -- set to `false` to disable one of the mappings
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        }
    },
    indent = {
        enable = true,
    }
})
