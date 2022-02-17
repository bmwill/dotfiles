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

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })

  -- Don't pass messages to |ins-completion-menu|
  vim.cmd [[set shortmess+=c]]
end
setup()

local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
      hi def link LspReferenceText CursorColumn
      hi def link LspReferenceRead LspReferenceText
      hi def link LspReferenceWrite LspReferenceText
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
      false
    )
  end
end

local function lsp_keymaps(bufnr)
  -- Use Coc and LSP for tag functions <C-]> and <C-\> (go to definition)
  vim.cmd [[setlocal tagfunc=v:lua.vim.lsp.tagfunc]]

  -- Configure the keyword program 'K' to use lsp hover
  vim.cmd [[command! -nargs=? MyLspHover :lua vim.lsp.buf.hover()]]
  vim.cmd [[setlocal keywordprg=:MyLspHover]]

  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
  vim.api.nvim_buf_set_keymap(
    bufnr,
    "n",
    "gl",
    '<cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>',
    opts
  )
  vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]



--   " Use `[g` and `]g` to navigate diagnostics
-- nmap <silent> [g <Plug>(coc-diagnostic-prev)
-- nmap <silent> ]g <Plug>(coc-diagnostic-next)

-- " Apply AutoFix to problem on the current line.
-- nmap <leader>qf  <Plug>(coc-fix-current)

-- " Symbol renaming
-- nmap <leader>cr  <Plug>(coc-rename)

-- " Run code actions
-- nmap <leader>ca v<Plug>(coc-codeaction-selected)

-- " Run code formatting
-- nmap <leader>cf  <Plug>(coc-format)

-- " Mappings using CoCList:
-- " Show all diagnostics.
-- nnoremap <silent> <leader>cd  :<C-u>CocList diagnostics<cr>
-- " Find symbol of current document
-- nnoremap <silent> <leader>co  :<C-u>CocList outline<cr>
-- " Search workspace symbols
-- nnoremap <silent> <leader>cs  :<C-u>CocList -I symbols<cr>
-- " list commands available
-- nnoremap <silent> <leader>cc  :<C-u>CocList commands<cr>
-- " manage extensions
-- nnoremap <silent> <leader>cx  :<C-u>CocList extensions<cr>
-- " Resume latest coc list
-- nnoremap <silent> <leader>cl  :<C-u>CocListResume<CR>

-- " restart CoC
-- nnoremap <silent> <leader>cR  :<C-u>CocRestart<CR>


end

local function on_attach(client, bufnr)
  lsp_keymaps(bufnr)
  lsp_highlight_document(client)
end

local client_capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = cmp_nvim_lsp.update_capabilities(client_capabilities)

lsp_installer.on_server_ready(function(server)
    local opts = {
        on_attach = on_attach,
        capabilities = capabilities,
    }

    if server.name == "rust_analyzer" then
        local rustopts = {
            tools = { -- rust-tools options
                autoSetHints = true,
                hover_with_actions = true,
                inlay_hints = {
                    show_parameter_hints = true,
                    parameter_hints_prefix = "",
                    other_hints_prefix = "",
                },
            },

            -- all the opts to send to nvim-lspconfig
            -- these override the defaults set by rust-tools.nvim
            -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
            server = vim.tbl_deep_extend("force", server:get_default_options(), opts, {
                settings = {
                    -- to enable rust-analyzer settings visit:
                    -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
                    ["rust-analyzer"] = {
                        completion = {
                            postfix = {
                                enable = false
                            }
                        },
                        -- enable clippy on save
                        checkOnSave = {
                            command = "clippy"
                        },
                        cargo = {
                            loadOutDirsFromCheck = true,
                        },
                        procMacro = {
                            enable = true,
                        },
                    }
                },
            }),
        }
        rust_tools.setup(rustopts)
        server:attach_buffers()
    else
        if server.name == "sumneko_lua" then
            local sumneko_opts = {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            library = {
                                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                [vim.fn.stdpath("config") .. "/lua"] = true,
                            },
                        },
                    },
                },
            }

            opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
        end
        -- This setup() function is exactly the same as lspconfig's setup function.
        -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
        server:setup(opts)
    end
end)
