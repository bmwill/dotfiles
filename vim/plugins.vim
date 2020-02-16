" plugin config file
"
set nocompatible              " be iMproved, required
filetype off                  " required

" Install Vundle
" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'tpope/vim-fugitive'

" YCM
" Once installed perform the following to compile with semantic support
"   cd ~/.vim/bundle/YouCompleteMe
"   ./install.py --clang-completer
"   ./install.py --racer-completer
Plugin 'ycm-core/YouCompleteMe'
set completeopt-=preview
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_extra_conf_globlist = ['~/work/*']
autocmd! FileType rust let g:ycm_rust_src_path = system('printf $(rustc --print sysroot)/lib/rustlib/src/rust/src')

Plugin 'rust-lang/rust.vim'
let g:rustfmt_autosave = 1
Plugin 'racer-rust/vim-racer'
let g:racer_experimental_completer = 1

if executable('brew')
    exe 'set rtp+=' . system('printf $(brew --prefix)/opt/fzf')
else
    Plugin 'junegunn/fzf'
endif

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
"                   - install from cmdline vim +PluginInstall +qall
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
