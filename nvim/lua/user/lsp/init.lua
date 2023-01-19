local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
  return
end

local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
  return
end

local status_ok, rust_tools = pcall(require, "rust-tools")
if not status_ok then
  return
end

local function setup()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    -- disable virtual text
    virtual_text = false,
    -- show signs
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  -- Show diagnostic popup on cursor hold
  vim.cmd [[
  augroup diagnostics_hover
    autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
  augroup END
  ]]

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })
end
setup()

local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.document_highlight then
    vim.cmd [[
      hi def link LspReferenceText CursorColumn
      hi def link LspReferenceRead LspReferenceText
      hi def link LspReferenceWrite LspReferenceText
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]]
  end
end

local function lsp_keymaps(client, bufnr)
  -- Use Coc and LSP for tag functions <C-]> and <C-\> (go to definition)
  vim.cmd [[setlocal tagfunc=v:lua.vim.lsp.tagfunc]]

  -- Configure the keyword program 'K' to use lsp hover
  vim.cmd [[command! -nargs=? MyLspHover :lua vim.lsp.buf.hover()]]
  vim.cmd [[setlocal keywordprg=:MyLspHover]]

  local function bufmap(keys, command)
    local opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(bufnr, "n", keys, command, opts)
  end

  bufmap("gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
  bufmap("gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
  bufmap("gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
  bufmap("gh", "<cmd>lua vim.lsp.buf.hover()<CR>")
  bufmap("gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
  bufmap("<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
  -- Symbol renaming
  bufmap("<leader>cr", "<cmd>lua vim.lsp.buf.rename()<CR>")
  -- bufmap("gr", "<cmd>lua vim.lsp.buf.references()<CR>")
  bufmap("gr", "<cmd>Telescope lsp_references<CR>")
  bufmap("<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
  -- bufmap("<leader>ca", "<cmd>Telescope lsp_code_actions theme=cursor<CR>")
  -- Use `[d` and `]d` to navigate diagnostics
  bufmap("[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>')
  bufmap("]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>')
  bufmap("gl", '<cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>')
  -- bufmap("<leader>ql", "<cmd>lua vim.diagnostic.setloclist()<CR>")
  bufmap("<leader>ql", "<cmd>Telescope diagnostics<CR>")
  bufmap("<leader>ld", "<cmd>Telescope diagnostics<CR>")
  bufmap("<leader>ls", "<cmd>Telescope lsp_workspace_symbols<CR>")
  bufmap("<leader>lo", "<cmd>Telescope lsp_document_symbols<CR>")

  --  Apply AutoFix to problem on the current line.
  vim.cmd [[ command! AutoFix execute 'lua require("user.lsp.autofix").autofix()' ]]
  bufmap("<leader>qf", "<cmd>AutoFix<CR>")

  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
  bufmap("<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>")

  vim.cmd [[
    augroup lsp_format_on_save
      autocmd! * <buffer>
      autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)
    augroup END
  ]]

  if client.name == "rust_analyzer" then
    bufmap("<leader>lh", "<cmd>RustToggleInlayHints<CR>")
  end
end

local function on_attach(client, bufnr)
  lsp_keymaps(client, bufnr)
  lsp_highlight_document(client)
end

local client_capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = cmp_nvim_lsp.default_capabilities(client_capabilities)

lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    },
  }

  if server.name == "rust_analyzer" then
    local rust_analyzer_opts = require("user.lsp.settings").rust_analyzer
    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
    local server_opts = vim.tbl_deep_extend("force", server:get_default_options(), opts, rust_analyzer_opts)
    local rust_tools_opts = require("user.lsp.settings").rust_tools

    opts = vim.tbl_deep_extend("force", rust_tools_opts, {
      server = server_opts,
    })

    rust_tools.setup(opts)
    server:attach_buffers()
  else
    if server.name == "sumneko_lua" then
      local sumneko_opts = require("user.lsp.settings").sumneko_lua
      opts = vim.tbl_deep_extend("force", opts, sumneko_opts)
    end
    -- This setup() function is exactly the same as lspconfig's setup function.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    server:setup(opts)
  end
end)

require "user.lsp.null-ls"
