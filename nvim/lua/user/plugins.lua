local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- My plugins here
  "nvim-lua/popup.nvim", -- An implementation of the Popup API from vim in Neovim
  "nvim-lua/plenary.nvim", -- Useful lua functions used by lots of plugins
  {
    "kyazdani42/nvim-tree.lua",
    dependencies = {
      "kyazdani42/nvim-web-devicons",
    },
  },

  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",
  -- gc - toggle comments
  "tpope/vim-commentary",
  -- ds - delete surrounding
  -- cs - change surrounding
  -- ys - add surrounding
  "tpope/vim-surround",
  -- Coercion of words
  -- https://github.com/tpope/vim-abolish
  "tpope/vim-abolish",

  -- Easily move to places in a buffer
  "phaazon/hop.nvim",

  -- use "rust-lang/rust.vim"
  "bmwill/rust.vim",

  -- Color Schemes
  -- Plugin 'tomasr/molokai' -- Molokai theme (currently pre-installed)
  -- {
  --   "morhetz/gruvbox",
  --   config = function() -- Gruvbox theme
  --     vim.g.gruvbox_italic = 1
  --   end,
  -- },

  -- Plugin 'connorholyday/vim-snazzy' " Snazzy - Requires 24-bit color
  -- Plugin 'arcticicestudio/nord-vim' " Nord - Requires 24-bit color

  "cespare/vim-toml",

  -- completion plugins
  "hrsh7th/nvim-cmp", -- The completion plugin
  "hrsh7th/cmp-buffer", -- buffer completions
  "hrsh7th/cmp-path", -- path completions
  "hrsh7th/cmp-cmdline", -- cmdline completions
  "saadparwaiz1/cmp_luasnip", -- snippet completions
  "hrsh7th/cmp-nvim-lsp", -- lsp completions
  "hrsh7th/cmp-nvim-lua", -- nvim specific lua completions

  -- snippets
  "L3MON4D3/LuaSnip", --snippet engine

  -- LSP
  "neovim/nvim-lspconfig", -- enable LSP
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "WhoIsSethDaniel/mason-tool-installer.nvim",

  "simrat39/rust-tools.nvim",
  'stevearc/conform.nvim', -- for formatters and linters

  -- Git
  "lewis6991/gitsigns.nvim",

  -- Telescope
  "nvim-telescope/telescope.nvim",
  "nvim-telescope/telescope-ui-select.nvim",

  -- Debugging
  -- use 'mfussenegger/nvim-dap'
  -- use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
})
