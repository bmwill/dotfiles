" plugin config file

" Install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')

" YCM
" Once installed perform the following to compile with semantic support
"   cd ~/.vim/bundle/YouCompleteMe
"   ./install.py --clang-completer
"   ./install.py --racer-completer
Plug 'ycm-core/YouCompleteMe'
set completeopt-=preview
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_extra_conf_globlist = ['~/work/*']
autocmd! FileType rust let g:ycm_rust_src_path = system('printf $(rustc --print sysroot)/lib/rustlib/src/rust/src')

let g:racer_experimental_completer = 1
Plug 'racer-rust/vim-racer'

Plug 'tpope/vim-fugitive'

let g:rustfmt_autosave = 1
Plug 'rust-lang/rust.vim'

if executable('brew')
    exe 'set rtp+=' . system('printf $(brew --prefix)/opt/fzf')
else
    Plug 'junegunn/fzf'
endif

" Color Schemes
" Plugin 'tomasr/molokai' " Molokai theme (currently pre-installed)
let g:gruvbox_italic=1
Plug 'morhetz/gruvbox' " Gruvbox theme
" Plugin 'connorholyday/vim-snazzy' " Snazzy - Requires 24-bit color
" Plugin 'arcticicestudio/nord-vim' " Nord - Requires 24-bit color

call plug#end()

" PlugInstall [name ...] [#threads]     Install plugins
" PlugUpdate [name ...] [#threads]      Install or update plugins
" PlugClean[!]                          Remove unlisted plugins (bang version will clean without prompt)
" PlugUpgrade                           Upgrade vim-plug itself
" PlugStatus                            Check the status of plugins
" PlugDiff                              Examine changes from the previous update and the pending changes
" PlugSnapshot[!] [output path]         Generate script for restoring the current snapshot of the plugins
