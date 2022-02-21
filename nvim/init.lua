-- Lua config for Neovim
-- https://github.com/nanotee/nvim-lua-guide

require "user.options"
require "user.keymaps"
require "user.plugins"
require "user.colorscheme"
require "user.completion"
require "user.lsp"
require "user.gitsigns"
require "user.telescope"
require "user.hop"

-- Line Return
-- Make sure Vim returns to the same line when you reopen a file.
vim.cmd [[
  augroup line_return
    autocmd!
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") && &ft !~# 'commit' |
      \   execute 'normal! g`"zvzz' |
      \ endif
  augroup END
]]

-- Standard In
-- Treat buffers from stdin (e.g.: echo foo | vim -) as scratch.
vim.cmd [[
  augroup ft_stdin
    autocmd!
    autocmd StdinReadPost * :set buftype=nofile
  augroup END
]]

function _G.ReloadConfig()
  for name, _ in pairs(package.loaded) do
    if name:match "^user" then
      package.loaded[name] = nil
    end
  end

  vim.cmd(":source " .. vim.env.MYVIMRC)
end

vim.cmd "command! ReloadConfig lua ReloadConfig()"

-- Status Line
vim.cmd [[
  set laststatus=2                  " Always displays the status line
  set statusline=%f\                " Tail of the filename
  set statusline+=%y                " Filetype
  set statusline+=%{FileFormat()}   " File Encoding/Format
  set statusline+=%r                " Read only flag
  set statusline+=%m                " Modified flag
  set statusline+=%=                " left/right separator
  set statusline+=%c%V,             " Cursor column
  set statusline+=%l/%L             " Cursor line/total lines
  set statusline+=\ %P              " Percent through file

  " Returns a string '[Encoding,Format]' for the statusline
  " if the encoding isn't 'utf-8' or the format isn't 'unix'
  function! FileFormat()
    let l:fmt = ''
    if &fenc != 'utf-8'
      let l:fmt = strlen(&fenc) ? &fenc : 'none'
    endif

    if &ff != 'unix'
      let l:fmt = strlen(l:fmt) ? l:fmt . ',' . &ff : &ff
    endif

    return strlen(l:fmt) ? '[' . l:fmt . ']' : ''
  endfunction
]]

-- ---- rust -----------------------------------------------------------

vim.cmd [[
  autocmd! FileType rust call SetupRustEnv()
  function! SetupRustEnv()
    nnoremap <buffer> <leader>rf :RustFmt<CR>
    nnoremap <buffer> <leader>rt :RustTest<CR>
    nnoremap <buffer> <leader>rT :RustTest!<CR>
    nnoremap <buffer> <leader>rr :Cruntarget<CR>
  endfunction
]]

-- Don't add files from the stdlib and third-party crates to the buffer list
vim.cmd [[
  autocmd! BufReadPost ~/.cargo/registry/* setlocal nobuflisted
  autocmd! BufReadPost ~/.rustup/* setlocal nobuflisted
]]

vim.cmd [[
" ----------------------------
"     Plugin Configuration
" ----------------------------

" ---- fugitive & git -------------------------------------------------
" https://github.com/tpope/vim-fugitive

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
