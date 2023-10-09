-- NOTE:
-- <Leader> and <LocalLeader> are set in the top-level init.lua

-- Modes
--  Short-name  Affected modes                            Help page       Vimscript equivalent
--  ''          Normal, Visual, Select, Operator-pending  mapmode-nvo     :map
--  'n'         Normal                                    mapmode-n       :nmap
--  'v'         Visual and Select                         mapmode-v       :vmap
--  's'         Select                                    mapmode-s       :smap
--  'x'         Visual                                    mapmode-x       :xmap
--  'o'         Operator-pending                          mapmode-o       :omap
--  '!'         Insert and Command-line                   mapmode-ic      :map!
--  'i'         Insert                                    mapmode-i       :imap
--  'l'         Insert, Command-line, Lang-Arg            mapmode-l       :lmap
--  'c'         Command-line                              mapmode-c       :cmap
--  't'         Terminal                                  mapmode-t       :tmap

-- Normal --

-- Disable going into command-line window
vim.keymap.set("n", "q:", "<Nop>")

-- Change j and k to move through wrapped lines
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- Jump to tag in a new split
vim.keymap.set("n", "<C-\\>", "<C-w>v<C-]>")

-- Toggle spelling
vim.keymap.set("n", "<leader>sp", ":setlocal spell!<CR>")
-- Rebuild .spl file from 'spellfile'
vim.keymap.set("n", "<leader>sP", ":mkspell! " .. vim.fn.stdpath "config" .. "/spell/dictionary.utf-8.add<CR>")

-- Clear Search highlighting when hitting 'return'
-- This unsets the 'last search pattern' register
vim.keymap.set("n", "<CR>", ":noh<CR><CR>")

-- Toggle [i]nvisible characters
vim.keymap.set("n", "<leader>i", ":set list!<CR>")

-- Make zO recursively open whatever fold we're in, even if it's partially open.
vim.keymap.set("n", "z0", "zcz0")

-- Save with <C-s>
vim.keymap.set("n", "<C-s>", ":silent update<CR>")
vim.keymap.set("i", "<C-s>", "<Esc>:silent update<CR>")
vim.keymap.set("v", "<C-s>", "<Esc>:silent update<CR>gv")

-- Remove all trailing whitespace by pressing <leader>ww
-- uses mark 'z'
vim.keymap.set("n", "<leader>ww", [[mz:let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>`z]])

-- Reload init.lua
vim.keymap.set("n", "<leader>sv", ":ReloadConfig<CR>")

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
vim.keymap.set("n", "<leader>n", ":call NumberToggle()<CR>")

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
vim.keymap.set("i", "<C-u>", "<Esc>gUiwgi")
-- because completion breaks <C-u>
vim.keymap.set("i", "<C-g><C-u>", "<Esc>gUiwgi")

-- Formatting
vim.keymap.set("n", "Q", "gqip")
vim.keymap.set("v", "Q", "gq")

-- Toggle Wrap
vim.keymap.set("n", "<leader>W", ":set wrap!<CR>")

-- highlight last inserted text
vim.keymap.set("n", "gV", "`[v`]")

-- Better window navigation
-- vim.keymap.set("n", "<C-h>", "<C-w>h")
-- vim.keymap.set("n", "<C-j>", "<C-w>j")
-- vim.keymap.set("n", "<C-k>", "<C-w>k")
-- vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("n", "<leader>e", ":Lex 30<cr>")

-- Resize with arrows
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>")
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>")
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>")

-- Navigate buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>")
vim.keymap.set("n", "<S-h>", ":bprevious<CR>")

-- Visual --
-- Stay in indent mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Move text up and down
vim.keymap.set("v", "<A-j>", ":m .+1<CR>==")
vim.keymap.set("v", "<A-k>", ":m .-2<CR>==")
vim.keymap.set("v", "p", '"_dP')

-- Visual Block --
-- Move text up and down
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv")
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv")
vim.keymap.set("x", "<A-j>", ":move '>+1<CR>gv-gv")
vim.keymap.set("x", "<A-k>", ":move '<-2<CR>gv-gv")

-- Window Navigation
-- see https://gist.github.com/mislav/5189704 and https://github.com/eliasnorrby/dotfiles/commit/76c2d72282412b4e03620139af358b7a0f10fe76
local window_navigation = function(direction)
  local window = vim.api.nvim_get_current_win()
  vim.cmd("silent! wincmd " .. direction)

  -- if we successuflly moved to a new window or we are not in tmux, bail
  if window ~= vim.api.nvim_get_current_win() or vim.env.TMUX == nil then
    return
  end

  local session = vim.split(vim.env.TMUX, ",", true)[3]
  vim.fn.system("tmux select-pane -t '$" .. session .. "' -" .. vim.fn.tr(direction, "phjkl", "lLDUR"))
end

vim.keymap.set("n", "<A-h>", function()
  window_navigation "h"
end)
vim.keymap.set("n", "<A-j>", function()
  window_navigation "j"
end)
vim.keymap.set("n", "<A-k>", function()
  window_navigation "k"
end)
vim.keymap.set("n", "<A-l>", function()
  window_navigation "l"
end)
