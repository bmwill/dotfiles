local M = {}

-- LSP settings for 'rust-analyzer'
-- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
M.rust_analyzer = {
  settings = {
    ["rust-analyzer"] = {
      completion = {
        postfix = {
          enable = true,
        },
      },
      -- enable clippy on save
      checkOnSave = {
        command = "clippy",
      },
      cargo = {
        loadOutDirsFromCheck = true,
        runBuildScripts = true,
      },
      procMacro = {
        enable = true,
      },
      -- rustfmt = {
      --   extraArgs = { "--config", "merge_imports=true" },
      -- },
    },
  },
}

-- 'rust-tools' plugin options
M.rust_tools = {
  tools = {
    -- hover_with_actions = true, -- Depricated
    inlay_hints = {
      auto = true,
      only_current_line = true,
      show_parameter_hints = false,
      parameter_hints_prefix = "<- ",
      other_hints_prefix = "=> ",
    },
  },
}

-- LSP settings for 'lua_ls'
M.lua_ls = {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
        disable = { "redefined-local" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.stdpath "config" .. "/lua"] = true,
        },
      },
    },
  },
}

return M
