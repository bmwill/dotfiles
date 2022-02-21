local colorscheme = "molokai"

-- make molokai look closer to the gui colors
vim.g.molokai_original = 0
vim.g.rehash256 = 1

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")

  -- use 'desert' as the default colorscheme if 'molokai' isn't found
  vim.cmd "colorscheme desert"
end

-- Highlight VCS conflict markers
vim.cmd [[match ErrorMsg '^\(<\|=\|>\||\)\{7\}\(.\+\)\?$']]

-- Use italics for comments
vim.cmd "highlight Comment cterm=italic"
