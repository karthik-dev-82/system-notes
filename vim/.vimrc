set nocompatible
filetype off
syntax enable

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-fugitive'
Plugin 'nanotech/jellybeans.vim'
Plugin 'altercation/vim-colors-solarized'
" NOTE: Lokaltog/vim-powerline is unmaintained (superseded by the
" standalone `powerline` project, or vim-airline for a vim-only
" statusline). Kept as-is here; see vim/README.md for details.
Plugin 'Lokaltog/vim-powerline'
" NOTE: syntastic is in upstream-declared maintenance mode; ALE
" (dense-analysis/ale) is the actively developed replacement. Kept
" as-is here; see vim/README.md for details.
Plugin 'scrooloose/syntastic'
Plugin 'preservim/nerdtree'
Plugin 'ctrlpvim/ctrlp.vim'

" All Plugin commands must come before this line
call vundle#end()
filetype plugin indent on

let mapleader=","

let g:solarized_termcolors=256
set t_Co=256
colorscheme solarized
set background=dark

set cursorline
set expandtab
set modelines=0
set shiftwidth=2
" unnamedplus = the real system clipboard (Ctrl+C/Ctrl+V) on Linux;
" plain "unnamed" maps to the X11 PRIMARY/selection register instead,
" which is not what most people expect. Requires vim built with
" +clipboard (e.g. the vim-gtk3 package, not vim-tiny). See vim/README.md.
set clipboard=unnamedplus
set synmaxcol=128
set ttyscroll=10
set encoding=utf-8
set tabstop=2
set nowrap
set number
set nowritebackup
set noswapfile
set nobackup
set hlsearch
set ignorecase
set smartcase

" Quick ESC
imap jj <ESC>

" Jump to the next row on long lines
map <Down> gj
map <Up>   gk
nnoremap j gj
nnoremap k gk

" format the entire file
nmap <leader>fef ggVG=

" Open new buffers
nmap <leader>s<left>   :leftabove  vnew<cr>
nmap <leader>s<right>  :rightbelow vnew<cr>
nmap <leader>s<up>     :leftabove  new<cr>
nmap <leader>s<down>   :rightbelow new<cr>


" NERDTree
nmap <leader>n :NERDTreeToggle<CR>
let NERDTreeHighlightCursorline=1
let NERDTreeIgnore = ['tmp', '.yardoc', 'pkg']

" CtrlP
nnoremap <silent> t :CtrlP<cr>
let g:ctrlp_working_path_mode = 2
let g:ctrlp_by_filename = 1
let g:ctrlp_max_files = 600
let g:ctrlp_max_depth = 5


let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'

