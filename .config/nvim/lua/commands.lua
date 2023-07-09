local lua_path = vim.fn.stdpath('config') .. "/lua"
vim.cmd.colorscheme("retrobox")
vim.api.nvim_create_user_command("Options", "edit " .. lua_path .. "/options.lua", {})
vim.api.nvim_create_user_command("Commands", "edit " .. lua_path .. "/commands.lua", {})
vim.api.nvim_create_user_command("Maps", "edit " .. lua_path .. "/maps.lua", {})
vim.api.nvim_create_user_command("Config", "edit " .. vim.fn.stdpath('config'), {})


