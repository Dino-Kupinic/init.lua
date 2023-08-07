local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
    "rust_analyzer",
})

-- Fix Undefined global 'vim'
lsp.configure("lua_ls", {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" }
            }
        }
    }
})

lsp.configure("clangd", {
    cmd = {
        "clangd",
        -- Fix clangd offset_encoding
        "--offset-encoding=utf-16",
        "--background-index",
        "--pch-storage=memory",
        "--all-scopes-completion",
        "--pretty",
        -- "--header-insertion=never", 
        "-j=4",
        "--inlay-hints",
        "--header-insertion-decorators",
        "--function-arg-placeholders",
        "--completion-style=detailed",
    },
})

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<C-x>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

-- On every buffer that uses an lsp
lsp.on_attach(function(_, bufnr)
    local opts = { buffer = bufnr, remap = false }
    local lspconfig = require("lspconfig")

    -- Intelephense folder not in home directory
    lspconfig.intelephense.setup {
        init_options = {
            globalStoragePath = os.getenv("HOME") .. "/.local/share/intelephense"
        }
    }

    vim.lsp.handlers["textDocument/signature_help"] = vim.lsp.with(
        vim.lsp.handlers.signature_help, {
            border = "rounded",
            close_events = { "CursorMoved", "BufHidden", "InsertCharPre" }
        }
    )
    -- go to definition
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    -- drüber hover (nur name)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    -- parameter preview (in funktion klammern)
    vim.keymap.set("n", "<C-n>", function() vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set("i", "<C-n>", function() vim.lsp.buf.signature_help() end, opts)
    -- format
    vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format() end, opts)
    -- view diagonostics, error preview
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    -- view next diagnostics, zum nächsten und preview
    vim.keymap.set("n", "<leader>vnd", function() vim.diagnostic.goto_next() end, opts)
    -- view previous d
    vim.keymap.set("n", "<leader>vpd", function() vim.diagnostic.goto_prev() end, opts)
    -- code action, vorschlag zum fixen
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    -- refactor/rename
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)

    local trouble = require("trouble")

    -- view workspace diagnostics, preview alle fehler hints usw
    vim.keymap.set("n", "<leader>vwd", function() trouble.open("workspace_diagnostics") end, opts)
    -- view all diagnostics, nur für jetzige file
    vim.keymap.set("n", "<leader>vad", function() trouble.open("document_diagnostics") end, opts)
    -- all usages von function zb
    vim.keymap.set("n", "<leader>vrr", function() trouble.open("lsp_references") end, opts)
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})
