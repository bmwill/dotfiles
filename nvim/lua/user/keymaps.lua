local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

-- Set <Leader> key
--vim.g.mapleader = ","
--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
keymap("", ",", "<leader>", { silent = true } )

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --

-- Disable going into command-line window
keymap("n", "q:", "<Nop>", opts)

-- Change j and k to move through wrapped lines
keymap("n", "j", "gj", opts)
keymap("n", "k", "gk", opts)

-- Jump to tag in a new split
keymap("n", "<C-\\>", "<C-w>v<C-]>", opts)

-- Toggle spelling
keymap("n", "<leader>sp", ":setlocal spell!<CR>", opts)
-- Rebuild .spl file from 'spellfile'
keymap("n", "<leader>sP", ":mkspell! " .. vim.fn.stdpath "config" .. "/spell/dictionary.utf-8.add<CR>", opts)

-- Clear Search highlighting when hitting 'return'
-- This unsets the 'last search pattern' register
keymap("n", "<CR>", ":noh<CR><CR>", opts)

-- Toggle [i]nvisible characters
keymap("n", "<leader>i", ":set list!<CR>", opts)

-- Make zO recursively open whatever fold we're in, even if it's partially open.
keymap("n", "z0", "zcz0", opts)


-- Save with <C-s>
keymap("n", "<C-s>", ":silent update<CR>", opts)
keymap("i", "<C-s>", "<Esc>:silent update<CR>", opts)
keymap("v", "<C-s>", "<Esc>:silent update<CR>gv", opts)

-- Remove all trailing whitespace by pressing <leader>ww
-- uses mark 'z'
keymap("n", "<leader>ww", [[mz:let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>`z]], opts)

-- Reload init.lua
keymap("n", "<leader>sv", ":ReloadConfig<CR>", opts)

-- Toggle Numbers
vim.cmd [[
    function! NumberToggle()
        if(&relativenumber == 1 && &number == 1)
            setlocal nonumber
            setlocal norelativenumber
        elseif (&number == 1)
            setlocal relativenumber
        else
            setlocal number
        endif
    endfunc
]]
keymap("n", "<leader>n", ":call NumberToggle()<CR>", opts)


-- "Uppercase word" mapping
--
-- This mapping allows you to press <c-u> in insert mode to convert the current
-- word to uppercase.  It's handy when you're writing names of constants and
-- don't want to use Capslock.
--
-- To use it you type the name of the constant in lowercase.  While your
-- cursor is at the end of the word, press <c-u> to uppercase it, and then
-- continue happily on your way:
--
--                            cursor
--                            v
--     max_connections_allowed|
--     <c-u>
--     MAX_CONNECTIONS_ALLOWED|
--                            ^
--                            cursor
--
-- It works by exiting out of insert mode using gUiw to uppercase inside the
-- current word, then gi to enter insert mode at the end of the word.
keymap("i", "<C-u>", "<Esc>gUiwgi", opts)
-- because completion breaks <C-u>
keymap("i", "<C-g><C-u>", "<Esc>gUiwgi", opts)

-- Formatting
keymap("n", "Q", "gqip", opts)
keymap("v", "Q", "gq", opts)

-- Toggle Wrap
keymap("n", "<leader>W", ":set wrap!<CR>", opts)

-- highlight last inserted text
keymap("n", "gV", "`[v`]", opts)

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

keymap("n", "<leader>e", ":Lex 30<cr>", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)
