options = {
    autowrite = true,
    backupext = ".bak",
    concealcursor = "",
    conceallevel = 0,
    cursorcolumn = true,
    cursorline = true,
    expandtab = true,
    hlsearch = false,
    incsearch = true,
    number = true,
    relativenumber = true,
    scrolloff = 8,
    shiftwidth = 4,
    smartindent = true,
    softtabstop = 4,
    tabstop = 4,
    tildeop = true,
    wrap = false,
}

for key,val in pairs(options) do
    vim.opt[key] = val
end

appends = {
    path = "**",
    wildignore = "*.class",
    wildignore = "**/target/**"
}

for key,val in pairs(appends) do
    vim.opt[key] = vim.opt[key] + val
end

netrw_options = { 
    banner = 0,
    liststyle = 3
}


