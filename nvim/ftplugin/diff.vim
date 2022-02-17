setlocal nomodeline
setlocal foldmethod=expr
setlocal foldexpr=DiffFoldLevel()
"setlocal foldcolumn=3

" Get fold level for diff mode
" Works with normal, context, unified, rcs, ed, subversion and git diffs.
" For rcs diffs, folds only files (rcs has no hunks in the common sense)
" foldlevel=1 ==> file
" foldlevel=2 ==> hunk
" context diffs need special treatment, as hunks are defined
" via context (after '***************'); checking for '*** '
" or ('--- ') only does not work, as the file lines have the
" same marker.
function! DiffFoldLevel()
  let l:line=getline(v:lnum)

  if l:line =~# '^\(diff\|Index\)'  " file
    return '>1'
  elseif l:line =~# '^\(@@\|\d\)'   " hunk
    return '>2'
  elseif l:line =~# '^\*\*\* \d\+,\d\+ \*\*\*\*$' " context: file1
    return '>2'
  elseif l:line =~# '^--- \d\+,\d\+ ----$'        " context: file2
    return '>2'
  else
    return '='
  endif
endfunction
