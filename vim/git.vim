" -----------------
"   Git Functions
" -----------------

" git grep
nnoremap <leader>gg :!git grep "<c-r>=expand("<cword>")<CR>"<CR>

" git blame
"nnoremap <leader>b :vertical leftabove new <Bar> setlocal buftype=nofile bufhidden=hide noswapfile <Bar> read !git blame <c-r>=expand('%')<CR><CR>

nnoremap <leader>gb :call Blame()<CR>
nnoremap <leader>gc :call ShowCommit()<CR>

"switchbuf=usetab
function! ShowCommit() abort
  " Quick return if the blame layer isn't open
  if bufwinnr(s:blamebufname) <= 0
    return
  endif

  let linenumber = line('.')
  let linecontents = getbufline('__gitblame__', linenumber)[0]
  "let commit = matchstr(getline('.'), '^\x\{8\}\x*')
  let commit = matchstr(linecontents, '^\x\{8\}\x*')
  "echo 'contents: ' . linecontents . 'commit: ' . commit
  "execute "botright split"
  "edit __gitcommit__
  "resize 10
  "setlocal winfixheight nolist nowrap nonumber buftype=nofile
  "setlocal ft=gitcommit
  "setlocal noswapfile
  "setlocal statusline=%t\ %y

  "normal ggdG
  "execute "silent read !git --no-pager show --no-patch --pretty=medium --decorate=on " . commit
  "execute "silent read !git --no-pager show --no-patch --pretty=medium --decorate=on HEAD"
  execute "!git --no-pager show --stat --pretty=medium --decorate=on " . commit
  "normal ggdd
endfunction

function! Test() abort
  let buffername = '__gitblame__'
  let bnr = bufwinnr(buffername)
  if bnr > 0
    ":exe bnr . "wincmd w"
    echo 'stuff'
  else
    echo buffername . ' is not existent'
    "silent execute 'split ' . a:buffername
  endif
endfunction

let s:blamebufname = '__gitblame__'
function! Blame() abort

  " Close the Blame layer if already open
  if bufwinnr(s:blamebufname) > 0
    execute "bdelete " . s:blamebufname
    return
  endif
  "if exists('s:blame_tab_exists')
  "  echo "exists"
  "endif
  "let s:blame_tab_exists=1
  "echo s:blame_tab_exists
  "echo "HEY"
  "let bufnu = bufnr('')
  "echo bufnu
  let linenumber = line('.')

  "let fn = expand('%:p')
  let fn = expand('%')

  "echo "filename: " . fn
  wincmd v
  wincmd h
  execute "edit " . s:blamebufname
  "vertical resize 28
  vertical resize 27

  setlocal scrollbind winfixwidth nolist nowrap nonumber buftype=nofile ft=none
  setlocal noswapfile
  setlocal statusline=%t\ %y

  normal ggdG
  execute "silent read !git --no-pager blame " . fn
  normal ggdd
  "execute ':%s/\v:.*$//'
  silent execute ':%s/\v\s\d*:.*$//'
  silent execute ':%s/(//'

  wincmd l
  setlocal scrollbind
  syncbind
endfunction
