require 'nvim-treesitter.configs'.setup({
    sync_install = false,
    highlight = {
        enable = true,
        disable = { "vim", "vimdoc" },
        additional_vim_regex_highlighting = false
    },

    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "+", -- set to `false` to disable one of the mappings
            node_incremental = "+",
            scope_incremental = "grc",
            node_decremental = "-",
        }
    },
    indent = {
        enable = true,
    }
})
