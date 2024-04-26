local jdtls = require'jdtls'
local capabilities = {
    workspace = {
        configuration = true
    },
    textDocument = {
        completion = {
            completionItem = {
                snippetSupport = true
            }
        }
    }
}

local cmp_capabilities = require'cmp_nvim_lsp'.default_capabilities()
capabilities = vim.tbl_extend("keep", capabilities, cmp_capabilities)

local function tagfunc(pattern)
    return vim.lsp.tagfunc(pattern, "c")
end

local arr = vim.fn.systemlist("projects")
local root_dir = arr[2]
local config = {
    capabilities = capabilities,
    cmd = { "jdtls", vim.fs.basename(root_dir) },
    on_attach = function(client)
        client.server_capabilities.semanticTokensProvider = nil
        vim.bo.tagfunc=tagfunc
    end,
    flags = { allow_incremental_sync = true },
    root_dir = root_dir,
    detached = false,
    settings = {
        java = {
            ['server.launchMode'] = 'Hybrid',
            ['contentProvider.preferred'] = 'fernflower',
            ['codeGeneration.addFinalForNewDeclaration'] = 'all',
            ['eclipse.downloadSources'] = true,
            ['maven.downloadSources'] = true,
            ['referencesCodeLens.enabled'] = true,
            ['references.includeDecompiledSources'] = true,
            ['inlayHints.parameterNames.enabled'] = "all",
            signatureHelp = {
                enabled = true,
                description = { enabled = true }
            },
            completion = {
                enabled = true,
                guessMethodArguments = 'insertBestGuessedArguments'
            },
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999
                }
            },
            format = {
                settings = {
                    url = "/home/ryan/formatter.xml"
                }
            }
        },
    },
}
require'treesitter-context'.setup{
    enable = false
}

jdtls.start_or_attach(config)
