-- :help options

local options = {
  spelllang = "en_us",
  spellfile = vim.fn.stdpath "config" .. "/spell/dictionary.utf-8.add",

  undofile = true, -- enable persistent undo
  pumheight = 15, -- pop up menu height
  updatetime = 1000, -- faster completion (4000ms default)
  timeoutlen = 1000, -- time to wait for a mapped sequence to complete (in milliseconds)
  fileencoding = "utf-8", -- the encoding written to a file
  -- termguicolors = true, -- set term gui colors (most terminals support this)
  showcmd = true, -- Display incomplete commands
  showmode = true, -- Display current mode
  autoread = true, -- read file when it is modified outside of vim
  autowrite = true, -- write file when running some buffer motion commands
  number = true, -- set numbered lines
  relativenumber = false, -- set relative numbered lines
  signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
  ruler = true, -- status line shows cursor position
  cursorline = true, -- highlight the line containing the cursor
  mouse = "a", -- enable the mouse to be used in neovim
  -- wildmenu = true, -- allow tab completion of commands
  -- wildmode = "longest:full", -- complete till longest common string
  scrolloff = 8, -- scroll 8 lines prior to horizontal border
  sidescrolloff = 8, -- scroll 8 lines prior to vertical border
  splitbelow = true, -- force all horizontal splits to go below current window
  splitright = true, -- force all vertical splits to go to the right of current window

  ----- Indentation -----
  autoindent = true, -- Copy indentation from previous line
  expandtab = true, -- Expands tabs into spaces
  tabstop = 8, -- Changes the width of the <TAB> character
  shiftwidth = 4, -- Affects how automatic indentation works (>>,<<,==)
  softtabstop = 4, -- Affects what happens when you press <TAB> or <BS>
  listchars = "tab:▸-,trail:·,eol:¬,nbsp:_", -- Show 'invisible' whitespace characters

  ----- Search -----
  incsearch = true, -- Search while typing
  hlsearch = true, -- Highlight matching searches
  ignorecase = true, -- ignore case while searching
  smartcase = true, -- ignore case only when all lowercase

  clipboard = "unnamedplus", -- allows neovim to access the system clipboard
  completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  -- swapfile = false, -- disables swapfiles
  -- writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
}

vim.opt.shortmess:append "c" -- Don't pass messages to |ins-completion-menu|
vim.opt.iskeyword:append "-" -- treat '-' as part of a 'word'

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.cmd "noh" -- force highlighting off when config is reloaded

-- Use ripgrep for grepping
if vim.fn.executable "rg" == 1 then
  vim.o.grepprg = "rg --vimgrep --hidden --glob '!.git'"
end
