-- :help options

vim.opt.spelllang = "en_us"
vim.opt.spellfile = vim.fn.stdpath "config" .. "/spell/dictionary.utf-8.add"

vim.opt.undofile = true                         -- enable persistent undo
vim.opt.pumheight = 15                          -- pop up menu height
vim.opt.updatetime = 1000                        -- faster completion (4000ms default)
vim.opt.timeoutlen = 1000                       -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.fileencoding = "utf-8"                  -- the encoding written to a file
--vim.opt.termguicolors = true                    -- set term gui colors (most terminals support this)
vim.opt.showcmd = true -- Display incomplete commands
vim.opt.showmode = true -- Display current mode
vim.opt.autoread = true -- read file when it is modified outside of vim
vim.opt.autowrite = true -- write file when running some buffer motion commands
vim.opt.number = true                           -- set numbered lines
vim.opt.relativenumber = false                  -- set relative numbered lines
-- vim.opt.signcolumn = "yes"                      -- always show the sign column, otherwise it would shift the text each time
vim.opt.ruler = true -- status line shows cursor position
vim.opt.cursorline = true -- highlight the line containing the cursor
vim.opt.mouse = "a"                             -- enable the mouse to be used in neovim
-- vim.opt.wildmenu = true -- allow tab completion of commands
-- vim.opt.wildmode = "longest:full" -- complete till longest common string
vim.opt.scrolloff = 8                           -- scroll 8 lines prior to horizontal border
vim.opt.sidescrolloff = 8                       -- scroll 8 lines prior to vertical border
vim.opt.splitbelow = true                       -- force all horizontal splits to go below current window
vim.opt.splitright = true                       -- force all vertical splits to go to the right of current window

----- Indentation -----
vim.opt.autoindent = true       -- Copy indentation from previous line
vim.opt.expandtab = true        -- Expands tabs into spaces
vim.opt.tabstop = 8               -- Changes the width of the <TAB> character
vim.opt.shiftwidth = 4            -- Affects how automatic indentation works (>>,<<,==)
vim.opt.softtabstop = 4           -- Affects what happens when you press <TAB> or <BS>
vim.opt.listchars = "tab:▸-,trail:·,eol:¬,nbsp:_"             -- Show 'invisible' whitespace characters
-- vim.opt.list = true

----- Search -----
vim.opt.incsearch = true        -- Search while typing
vim.opt.hlsearch = true         -- Highlight matching searches
vim.opt.ignorecase = true       -- ignore case while searching
vim.opt.smartcase = true        -- ignore case only when all lowercase
vim.cmd "noh"                   -- force highlighting off when config is reloaded


vim.opt.clipboard = "unnamedplus"               -- allows neovim to access the system clipboard
vim.opt.completeopt = { "menuone", "noselect" } -- mostly just for cmp
-- vim.opt.swapfile = false                        -- disables swapfiles
-- vim.opt.writebackup = false                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
-- vim.opt.wrap = false                            -- display lines as one long line

vim.opt.shortmess:append "c"

vim.cmd [[set iskeyword+=-]] -- treat '-' as part of a 'word'
