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
