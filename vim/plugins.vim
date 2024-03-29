" plugin config file

" Install vim-plug
" https://github.com/junegunn/vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
" gc - toggle comments
Plug 'tpope/vim-commentary'
" ds - delete surrounding
" cs - change surrounding
" ys - add surrounding
Plug 'tpope/vim-surround'
" Coercion of words
" https://github.com/tpope/vim-abolish
Plug 'tpope/vim-abolish'

if executable('brew')
    exe 'set rtp+=' . system('printf $(brew --prefix)/opt/fzf')
else
    Plug 'junegunn/fzf'
endif

" Peak at contents of registers with ", @, and <C-R>
Plug 'junegunn/vim-peekaboo'

" Color Schemes
" Plugin 'tomasr/molokai' " Molokai theme (currently pre-installed)
let g:gruvbox_italic=1
Plug 'morhetz/gruvbox' " Gruvbox theme
" Plugin 'connorholyday/vim-snazzy' " Snazzy - Requires 24-bit color
" Plugin 'arcticicestudio/nord-vim' " Nord - Requires 24-bit color

Plug 'cespare/vim-toml'

call plug#end()

" PlugInstall [name ...] [#threads]     Install plugins
" PlugUpdate [name ...] [#threads]      Install or update plugins
" PlugClean[!]                          Remove unlisted plugins (bang version will clean without prompt)
" PlugUpgrade                           Upgrade vim-plug itself
" PlugStatus                            Check the status of plugins
" PlugDiff                              Examine changes from the previous update and the pending changes
" PlugSnapshot[!] [output path]         Generate script for restoring the current snapshot of the plugins
