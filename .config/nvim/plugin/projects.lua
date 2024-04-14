local result = vim.fn.systemlist("projects")
if vim.v.shell_error ~= 0 then return end
local config_home = result[1] .. "/nvim"
vim.g.projectState = result[1]
vim.g.projectPath = result[2]

local augroup = vim.api.nvim_create_augroup('Sessions', {})
-- If its the first time launching vim in a config_home folder
-- we need to create it and create a first session file
-- the shada file will be created later in the neovim startup sequence
local shada = config_home .. "/project.shada"
-- vim.print(shada)
local nvimrc = config_home .. "/nvimrc"
local vimscript = config_home .. "/script.vim"
local luascript = config_home .. "/script.lua"
if vim.fn.finddir(config_home, result[1]) == '' then
    vim.fn.mkdir(config_home, "p")
    vim.cmd('mkvimrc ' .. nvimrc)
    vim.fn.writefile({}, vimscript)
    vim.fn.writefile({}, luascript)
end
vim.o.shada = "!,'100,<50,s10,h"
vim.o.shadafile = shada

-- vim.o.sessionoptions = "curdir,globals,options"
-- local session = config_home .. "/Session.vim"
local projectStateWinId = -1
local edit_project_scripts = function()
    if vim.fn.win_gotoid(projectStateWinId) == 0 then
        vim.cmd("tabnew " .. vim.g.projectState)
        vim.cmd("tcd " .. vim.g.projectState)
        projectStateWinId = vim.fn.win_getid()
    end
end
local cd_project_path = function()
    vim.cmd("cd " .. vim.g.projectPath)
end
vim.api.nvim_create_user_command("EditProjectState", edit_project_scripts, {nargs = 0})
vim.api.nvim_create_user_command("CdProjectPath", cd_project_path, {nargs = 0})
vim.keymap.set("n", "<C-x><C-e>", "<cmd>EditProjectState<cr>")
vim.keymap.set("n", "<C-x><C-d>", "<cmd>CdProjectPath<cr>")

vim.api.nvim_create_autocmd("VimEnter", {
    group = augroup,
    pattern = "*",
    callback = function()
        vim.cmd("silent source " .. nvimrc)
        vim.cmd("silent source " .. vimscript)
        vim.cmd("silent source " .. luascript)
        require'colors'.set_colorscheme(vim.o.background, vim.g.COLOR_NAME)
    end
})
vim.api.nvim_create_autocmd("VimLeavePre", {
    group = augroup,
    pattern = "*",
    callback = function()
        vim.g.COLOR_NAME = vim.g.colors_name
        vim.cmd("mkvimrc! " .. nvimrc)
    end
})
