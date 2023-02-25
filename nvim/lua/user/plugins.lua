local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
  compile_path = install_path .. "/plugin/packer.lua",
})

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used by lots of plugins
  use({ "kyazdani42/nvim-tree.lua", requires = "kyazdani42/nvim-web-devicons" })

  use "tpope/vim-fugitive"
  use "tpope/vim-rhubarb"
  -- gc - toggle comments
  use "tpope/vim-commentary"
  -- ds - delete surrounding
  -- cs - change surrounding
  -- ys - add surrounding
  use "tpope/vim-surround"
  -- Coercion of words
  -- https://github.com/tpope/vim-abolish
  use "tpope/vim-abolish"

  -- Easily move to places in a buffer
  use "phaazon/hop.nvim"

  -- use "rust-lang/rust.vim"
  use "bmwill/rust.vim"

  -- Color Schemes
  -- Plugin 'tomasr/molokai' -- Molokai theme (currently pre-installed)
  vim.g.gruvbox_italic = 1
  use "morhetz/gruvbox" -- Gruvbox theme
  -- Plugin 'connorholyday/vim-snazzy' " Snazzy - Requires 24-bit color
  -- Plugin 'arcticicestudio/nord-vim' " Nord - Requires 24-bit color

  use "cespare/vim-toml"

  -- completion plugins
  use "hrsh7th/nvim-cmp" -- The completion plugin
  use "hrsh7th/cmp-buffer" -- buffer completions
  use "hrsh7th/cmp-path" -- path completions
  use "hrsh7th/cmp-cmdline" -- cmdline completions
  use "saadparwaiz1/cmp_luasnip" -- snippet completions
  use "hrsh7th/cmp-nvim-lsp" -- lsp completions
  use "hrsh7th/cmp-nvim-lua" -- nvim specific lua completions

  -- snippets
  use "L3MON4D3/LuaSnip" --snippet engine

  -- LSP
  use "neovim/nvim-lspconfig" -- enable LSP
  use({ "williamboman/mason.nvim" })
  use({ "williamboman/mason-lspconfig.nvim" })
  use({ "WhoIsSethDaniel/mason-tool-installer.nvim" })

  -- use({ "simrat39/rust-tools.nvim", commit = "7b4d155dd47e211ee661cbb4c7969b245f768edb" })
  use "simrat39/rust-tools.nvim"
  use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters

  -- Git
  use "lewis6991/gitsigns.nvim"

  -- Telescope
  use "nvim-telescope/telescope.nvim"
  use({ "nvim-telescope/telescope-ui-select.nvim" })

  -- Debugging
  -- use 'mfussenegger/nvim-dap'
  -- use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
