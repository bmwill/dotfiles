" ---- coc ------------------------------------------------------------
" additional configuration in ~/.vim/coc-settings.json

if !has_key(plugs, 'coc.nvim')
    finish
endif

" Extensions to be auto-installed
let g:coc_global_extensions = ['coc-rust-analyzer', 'coc-json']

" Highlight symbol under cursor on CursorHold
" Use CocHighlightText to change the highlight color
set updatetime=300
autocmd CursorHold * silent call CocActionAsync('highlight')

" Don't pass messages to |ins-completion-menu|
set shortmess+=c

" Cycle through and accept completion
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use Coc and LSP for tag functions <C-]> and <C-\> (go to definition)
" Maybe this functionality can extend to other goto functions?
" https://github.com/neoclide/coc.nvim/issues/1054
set tagfunc=CocTagFunc

" gd - go to definition of word under cursor
nmap <silent> gd <Plug>(coc-definition)
" gd - go to definition of the type of the variable under cursor
nmap <silent> gy <Plug>(coc-type-definition)
" gi - go to implementation
nmap <silent> gi <Plug>(coc-implementation)
" gr - find references of an identifier
nmap <silent> gr <Plug>(coc-references)

" gh - get hint on whatever's under the cursor
command! -nargs=? CocHover :call CocAction('doHover', <f-args>)
nnoremap <silent> gh :CocHover<CR>

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Symbol renaming
nmap <leader>cr  <Plug>(coc-rename)

" Run code actions
nmap <leader>ca  <Plug>(coc-codeaction)

" Run code formatting
nmap <leader>cf  <Plug>(coc-format)

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <leader>cd  :<C-u>CocList diagnostics<cr>
" Find symbol of current document
nnoremap <silent> <leader>co  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <leader>cs  :<C-u>CocList -I symbols<cr>
" list commands available
nnoremap <silent> <leader>cc  :<C-u>CocList commands<cr>
" manage extensions
nnoremap <silent> <leader>cx  :<C-u>CocList extensions<cr>
" Resume latest coc list
nnoremap <silent> <leader>cl  :<C-u>CocListResume<CR>

" restart CoC
nnoremap <silent> <leader>cR  :<C-u>CocRestart<CR>
