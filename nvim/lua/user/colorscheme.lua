local colorscheme = "molokai"

-- make molokai look closer to the gui colors
vim.g.molokai_original = 0
vim.g.rehash256 = 1

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")

  -- use 'desert' as the default colorscheme if 'molokai' isn't found
  vim.cmd "colorscheme desert"

  return
end

-- Highlight VCS conflict markers
vim.cmd [[match ErrorMsg '^\(<\|=\|>\||\)\{7\}\(.\+\)\?$']]

-- Italics
vim.cmd [[
    if &term =~ 'xterm-256color'
        let &t_ZH ="\<Esc>[3m"
        let &t_ZR ="\<Esc>[23m"
    endif
]]

-- Use italics for comments
vim.cmd "highlight Comment cterm=italic"

-- disable Background Color Erase (BCE) so that color schemes
-- render properly when inside 256-color tmux and GNU screen.
vim.cmd [[
    if &term =~ '256color'
        set t_ut=
    endif
]]
