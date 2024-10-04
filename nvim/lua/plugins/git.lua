-- GitSigns Config
local gitsigns_opts = {
  signs = {
    add          = { text = '▎' },
    change       = { text = '▎' },
    delete       = { text = '契' },
    topdelete    = { text = '契' },
    changedelete = { text = '▎' },
    untracked    = { text = '┆' },
  },
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true,
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000,
  preview_config = {
    -- Options passed to nvim_open_win
    border = "single",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
}

local fugitive_config = function()
  vim.cmd [[
" Maybe add a mapping for :Gblame --reverse
nnoremap <leader>gb :call Blame()<CR>
function! Blame() abort
  if &filetype ==# 'fugitiveblame'
    " close the blame layer
    normal gq
  else
    execute "Git blame"
  endif
endfunction

nnoremap <leader>gc :call ShowCommit()<CR>
function! ShowCommit() abort
  " Quick return if the blame layer isn't open
  if &filetype !=# 'fugitiveblame'
    echo "Not in fugitiveblame buffer"
  else
    let commit = matchstr(getline('.'), '\x\{,8}\x')

    execute "botright split"
    execute "resize 20"
    execute "terminal git --no-pager log -1 " . commit

    normal gg
  endif
endfunction

augroup fugitive_autocmds
  autocmd!
  autocmd BufReadPost fugitive://* set bufhidden=wipe
augroup END
]]
end

return {
  {
    "tpope/vim-fugitive",
    config = fugitive_config,
  },

  "tpope/vim-rhubarb",

  {
    "lewis6991/gitsigns.nvim",
    opts = gitsigns_opts,
  },
}
