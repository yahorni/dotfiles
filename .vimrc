" Get the defaults that most users want.
" source $VIMRUNTIME/defaults.vim

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
silent! call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" latex
Plugin 'ying17zi/vim-live-latex-preview'
Plugin 'lervag/vimtex'

" markdown highlight
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'

" other
Plugin 'scrooloose/nerdtree'
Plugin 'lyokha/vim-xkbswitch'
Plugin 'alvan/vim-closetag'
Plugin 'jiangmiao/auto-pairs'

" python plugins
Plugin 'klen/python-mode'
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
set viminfo="~/Service/viminfo"
set clipboard=unnamedplus
set omnifunc=htmlcomplete#CompleteTags

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

" normal mode bindings
nnoremap <Enter> o<ESC>
nnoremap S i<Enter><ESC>
nnoremap <Backspace> i<Backspace><ESC>l
nnoremap gr :noh<Enter>
nnoremap gl $
nnoremap Y y$

" brackets autocomplete
" inoremap " ""<left>
" inoremap ' ''<left>
" inoremap ( ()<left>
" inoremap [ []<left>
" inoremap { {}<left>
" inoremap {<CR> {<CR>}<ESC>O<Tab>

" moving in insert mpde
inoremap <C-H> <Left>
inoremap <C-L> <Right>

" different cursors per mode
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" folding
set foldmethod=indent
set foldlevel=99
nnoremap <space> za

" split direction 
set splitbelow
set splitright

" tab/split moving
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" enable autoswitching language
let g:XkbSwitchEnabled = 1
" NERDTree bind
map <C-n> :NERDTreeToggle<CR>
" Enable docstrings in folding
let g:SimpylFold_docstring_preview=1
" Disable choose first function/method at autocomplete
let g:jedi#popup_select_first = 0
let g:jedi#use_splits_not_buffers = "left"

" Tag closing
let g:closetag_filenames = '*'
let g:closetag_filetypes = '*'
let g:closetag_shortcut = '>'
let g:closetag_emptyTags_caseSensitive = 1
nnoremap <leader>t :CloseTagToggleBuffer<CR>
autocmd BufNewFile,BufRead * :CloseTagDisableBuffer

" Auto-pairs toggling
let g:AutoPairsShortcutToggle = '<leader>p'

" python pep8 indentations
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

" python mode settings
" python3 syntax
let g:pymode_python = 'python3'
" disable code completion
let g:pymode_rope = 0
let g:pymode_rope_completion = 0
let g:pymode_rope_complete_on_dot = 0
" code checks
let g:pymode_lint = 1
let g:pymode_lint_checker = "pyflakes,pep8"
" let g:pymode_lint_ignore="E501,W601,C0110"
" check after saving
let g:pymode_lint_write = 1
" support virtualenv
let g:pymode_virtualenv = 1
" syntax
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all
" disable folding
let g:pymode_folding = 0
" ability to run code
let g:pymode_run = 1
let g:pymode_run_bind = '<leader>e'
" some python bindings
autocmd BufNewFile,BufRead *.py nnoremap <leader>l :PymodeLint<CR>
autocmd BufNewFile,BufRead *.py nnoremap <leader>L :PymodeLintAuto<CR>
