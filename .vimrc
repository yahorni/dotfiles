" Get the defaults that most users want.
" source $VIMRUNTIME/defaults.vim

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" latex preview
Plugin 'ying17zi/vim-live-latex-preview'

" markdown highlight
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'

" other
Plugin 'scrooloose/nerdtree'

" python plugins
Plugin 'tmhedberg/SimpylFold'"
Plugin 'vim-scripts/indentpython.vim'
Plugin 'davidhalter/jedi-vim'

call vundle#end()
filetype plugin indent on

" some custom settings
let skip_defaults_vim=1
syntax on
set encoding=utf-8
set showcmd
set autoindent
set hlsearch
" set viminfo="$HOME/Service/viminfo"
set clipboard=unnamedplus

" set tabs as 4 spaces
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab

" hybrid line numbers
set nu
set number relativenumber

" colorscheme
colo ron

" disable backups
set nobackup
set nowritebackup
set noundofile

nmap <Enter> o<ESC>
nmap S i<Enter><ESC>
nmap <Backspace> i<Backspace><ESC>l
nmap gr :noh<Enter>
nmap gl $
nmap Y y$

" brackets autocomplete
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O<Tab>

" moving in insert mpde
inoremap <C-H> <Left>
inoremap <C-L> <Right>

" different cursors per mode
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

set foldmethod=indent
set foldlevel=99
nnoremap <space> za

set splitbelow
set splitright

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" NERDTree bind
map <C-n> :NERDTreeToggle<CR>
" Enable docstrings in folding
let g:SimpylFold_docstring_preview=1
" Disable choose first function/method at autocomplete
let g:jedi#popup_select_first = 0
let g:jedi#use_splits_not_buffers = "left"

" python pep8 indentations
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix
