require('tabline').setup({
    no_name = '[No Name]',
    modified_icon = '',
    close_icon = '',
    separator = "▌",
    padding = 3,
    color_all_icons = false,
    right_separator = false,
    show_index = false,
    show_icon = true,
})
require('kanagawa').setup({
    undercurl = false,
})
require'marks'.setup {
  -- whether to map keybinds or not. default true
  default_mappings = true,
  mappings = {
    next = false,
    prev = false
    }
}


vim.cmd("colo kanagawa")
