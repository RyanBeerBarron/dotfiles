require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename' },
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress', 'filesize'},
    lualine_z = {'location', 'searchcount', 'selectioncount'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

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
