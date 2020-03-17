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
"nmap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gd :call <SID>jumpWrapper('jumpDefinition')<CR>
" gy - go to definition of the type of the variable under cursor
"nmap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gy :call <SID>jumpWrapper('jumpTypeDefinition')<CR>
" gi - go to implementation
"nmap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gi :call <SID>jumpWrapper('jumpImplementation')<CR>
" gr - find references of an identifier
"nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> gr :call <SID>jumpWrapper('jumpReferences')<CR>

" Wrapper for using CoC jump actions which pushes tags onto the tag stack
" allowing the use of <C-t> for popping tags off the stack.
function! s:jumpWrapper(action) abort
    " Early return if the action isn't a jump
    if ! (a:action ==# "jumpDefinition" ||
    \     a:action ==# "jumpDeclaration" ||
    \     a:action ==# "jumpImplementation" ||
    \     a:action ==# "jumpTypeDefinition" ||
    \     a:action ==# "jumpReferences"
    \)
        return v:false
    endif

    let l:current_tag = expand('<cWORD>')

    let l:current_position    = getcurpos()
    let l:current_position[0] = bufnr()

    let l:current_tag_stack = gettagstack()
    let l:current_tag_index = l:current_tag_stack['curidx']
    let l:current_tag_items = l:current_tag_stack['items']

    if CocAction(a:action)
        let l:new_tag_index = l:current_tag_index + 1
        let l:new_tag_item = [#{tagname: l:current_tag, from: l:current_position}]
        let l:new_tag_items = l:current_tag_items[:]
        if l:current_tag_index <= len(l:current_tag_items)
            call remove(l:new_tag_items, l:current_tag_index - 1, -1)
        endif
        let l:new_tag_items += l:new_tag_item

        call settagstack(winnr(), #{curidx: l:new_tag_index, items: l:new_tag_items}, 'r')
    endif
endfunction

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
