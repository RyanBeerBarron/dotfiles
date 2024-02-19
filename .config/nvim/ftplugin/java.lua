local root_dir = vim.fs.dirname(vim.fs.find({"build.sh", "pom.xml"}, {upward = true})[1])
vim.g.RootDir = root_dir
local config = {
    cmd = { "jdtls_startup", root_dir },
    root_dir = root_dir,
    detached = false,
    settings = {
        java = {
            format = {
                settings = {
                    url = "/home/ryan/formatter.xml"
                }
            }

        }
    }
}
require('jdtls').start_or_attach(config)
