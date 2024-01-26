local build, run, test = vim.g.Build or {}, vim.g.Run or {} , vim.g.Test or {}
local cmd_buffers = {build, run, test}

local function create_buffer(buffer_name)
    local bufnr = vim.fn.bufadd(buffer_name)
    vim.fn.setbufvar(bufnr, "&buftype", "nofile")
    vim.fn.setbufvar(bufnr, "&buflisted", 0)
    return bufnr
end

local function create_win(bufnr)
    local original_win = vim.api.nvim_get_current_win()

    for _, buf in ipairs(cmd_buffers) do
        if bufnr ~= buf.bufnr then
            local winid = vim.fn.bufwinid(buf.bufnr)
            if winid ~= -1 then
                vim.api.nvim_set_current_win(winid)
                vim.cmd("sbuffer " .. bufnr)
                local cur_win = vim.api.nvim_get_current_win()
                vim.fn.setwinvar(cur_win, "&wrap", true)
                vim.api.nvim_set_current_win(original_win)
                return
            end
        end
    end
    local columns = math.floor(vim.o.columns * 0.33)
    vim.cmd("botright " .. columns .. "vsplit")
    local winid = vim.api.nvim_get_current_win()
    vim.wo[winid].number = false
    vim.wo[winid].foldcolumn = "0"
    vim.wo[winid].wrap = true
    vim.wo[winid].cursorline = false
    vim.wo[winid].cursorcolumn = false
    vim.cmd("buffer " .. bufnr)
    vim.api.nvim_set_current_win(original_win)
    return
end

local function close_wins()
    for _, truc in ipairs(cmd_buffers) do
        local winid = vim.fn.bufwinid(truc.bufnr)
        if winid ~= -1 then
            vim.api.nvim_win_close(winid, true)
        end
    end
end

local function split(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end

local function removeEmptyStrings(strings)
    for i = #strings, 1, -1 do
        if strings[i] == "" then
            table.remove(strings, i)
        end
    end
end

local function append(bufnr)
    return function(_, data)
        if data then
            if type(data) == "table" then removeEmptyStrings(data) end
            vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
        end
    end
end

build.name = "[Build output]"
run.name = "[Run output]"
test.name = "[Test output]"

build.bufnr = build.bufnr or create_buffer(build.name)
run.bufnr = run.bufnr or create_buffer(run.name)
test.bufnr = test.bufnr or create_buffer(test.name)

build.global_name = "Build"
run.global_name = "Run"
test.global_name = "Test"

vim.g.Build = build
vim.g.Run = run
vim.g.Test = test

local function exec(buffer)
    local cmd_var = buffer.global_name .. "_cmd"
    local cmd = vim.g[cmd_var]
    if cmd == nil then
        print("no cmd for " .. buffer.name)
        return 1
    end
    local cmd_table = split(cmd)
    vim.api.nvim_buf_set_lines(buffer.bufnr, 0, -1, false, {"output of: " .. cmd})
    if buffer.jobid then vim.fn.jobstop(buffer.jobid) end
    buffer.jobid = vim.fn.jobstart(cmd_table, {
        on_stdout = append(buffer.bufnr),
        on_stderr = append(buffer.bufnr),
        on_exit = function()
        vim.cmd("cbuffer " .. buffer.bufnr)
        end
    })
    vim.g[buffer.global_name] = buffer
    if vim.fn.bufwinid(buffer.bufnr) == -1 then
        create_win(buffer.bufnr)
    end
end
vim.api.nvim_create_user_command("Close", close_wins, {})

vim.keymap.set("n", "<M-t>", function() exec(test) end)
vim.keymap.set("n", "<M-m>", function() exec(build) end)
vim.keymap.set("n", "<M-r>", function() exec(run) end)
vim.keymap.set("n", "<leader>cl", close_wins)
