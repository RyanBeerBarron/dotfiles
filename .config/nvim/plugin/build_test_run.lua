---@class cmd
---@field jobid integer?
---@field winnr integer
---@field bufnr integer
---@field name string
---@field cmd_key string
---@field errorformat_key string

---@type fun(cmd_name: string): cmd
local function new_cmd(cmd_name)
    return {
        jobid = nil,
        winnr = -1,
        bufnr = -1,
        name = cmd_name,
        cmd_key = string.upper(cmd_name) .. "_CMD",
        errorformat_key = string.upper(cmd_name) .. "_ERRORFORMAT"
    }
end

---@type cmd
local build = new_cmd("Build")

---@type cmd
local test = new_cmd("Test")

---@type cmd
local run = new_cmd("Run")

---@type cmd[]
local cmds = {
    build,
    test,
    run
}

---@type fun(nil): integer
local function create_win()
    for _, cmd in ipairs(cmds) do
        if vim.api.nvim_win_is_valid(cmd.winnr) then
            vim.api.nvim_set_current_win(cmd.winnr)
            vim.cmd("vnew")
            return vim.api.nvim_get_current_win()
        end
    end
    local lines = math.floor(vim.o.lines * 0.33)
    vim.cmd("botright " .. lines .. "new")
    vim.wo.spell = false
    return vim.api.nvim_get_current_win()
end

---@type fun(cmd: cmd, args: string): nil
local function exec(cmd, args)
    local errorformat = vim.b[cmd.errorformat_key] or vim.g[cmd.errorformat_key]
    if errorformat == nil then
        print("Error, no errorformat for " .. cmd.name)
        return
    end
    local command = vim.b[cmd.cmd_key] or vim.g[cmd.cmd_key]
    if command == nil then
        print("Error, no command for " .. cmd.name)
        return
    end
    command = command .. args
    -- Async with nvim builtin term
    local original_window = vim.api.nvim_get_current_win()
    if cmd.jobid then vim.fn.jobstop(cmd.jobid) end
    -- if vim.api.nvim_win_is_valid(cmd.winnr) then
    --     vim.api.nvim_buf_delete(cmd.bufnr, { force = 1 })
    -- end
    cmd.winnr = create_win()
    cmd.bufnr = vim.api.nvim_get_current_buf()

    cmd.jobid = vim.fn.termopen(command, {
        on_exit = function()
            vim.cmd("cgetbuf " .. cmd.bufnr)
        end
    })
    vim.fn.setbufvar(cmd.bufnr, "&errorformat", errorformat)
    vim.cmd("normal! G")
    vim.api.nvim_set_current_win(original_window)
end

local function print_exec(cmd)
    local errorformat = vim.b[cmd.errorformat_key] or vim.g[cmd.errorformat_key]
    if errorformat == nil then
        print("Error, no errorformat for " .. cmd.name)
        return
    end
    local command = vim.b[cmd.cmd_key] or vim.g[cmd.cmd_key]
    if command == nil then
        print("Error, no command for " .. cmd.name)
        return
    end
    print("For " .. cmd.name .. " errorformat is: " .. errorformat)
    print("For " .. cmd.name .. " command is: " .. command)
end

local function close_wins()
    for _, cmd in ipairs(cmds) do
        if vim.api.nvim_win_is_valid(cmd.winnr) then
            vim.api.nvim_win_close(cmd.winnr, true)
            cmd.winnr = -1
        end
    end
end
vim.keymap.set("n", "<leader>cl", close_wins)

vim.api.nvim_create_user_command("ExecBuild", function(opts) exec(build, opts.args) end, { nargs = "*" })
vim.api.nvim_create_user_command("ExecTest", function(opts) exec(test, opts.args) end, { nargs = "*" })
vim.api.nvim_create_user_command("ExecRun", function(opts) exec(run, opts.args) end, { nargs = "*" })

vim.api.nvim_create_user_command("PrintBuild", function() print_exec(build) end, {})
vim.api.nvim_create_user_command("PrintTest", function() print_exec(test) end, {})
vim.api.nvim_create_user_command("PrintRun", function() print_exec(run) end, {})

vim.keymap.set("n", "<leader>pb", "<cmd>PrintBuild<cr>", {})
vim.keymap.set("n", "<leader>pt", "<cmd>PrintTest<cr>", {})
vim.keymap.set("n", "<leader>pr", "<cmd>PrintRun<cr>", {})

vim.keymap.set("n", "<A-m>", "<cmd>ExecBuild<cr>", {})
