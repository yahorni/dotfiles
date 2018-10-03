set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

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
Plugin 'scrooloose/nerdcommenter'
Plugin 'ervandew/supertab'

" python plugins
Plugin 'vim-scripts/indentpython.vim'
Plugin 'dbsr/vimpy'
Plugin 'davidhalter/jedi-vim'
Plugin 'w0rp/ale'

" Plugin 'tmhedberg/SimpylFold'"

call vundle#end()

filetype plugin indent on
filetype plugin on

" some custom settings
let skip_defaults_vim=1
syntax on
set encoding=utf-8
set showcmd
set autoindent
set hlsearch
" set viminfo="-"
set clipboard=unnamedplus

" set tabs as 4 spaces
set tabstop=4
set shiftwidth=4
" set expandtab
set smarttab

" hybrid line numbers
set nu
set number relativenumber

" colorscheme
colo ron

" disable Ex mode
nnoremap Q <nop>

" annoying keys
command! Q :q
command! W :w
command! WQ :wq
command! Wq :wq
command! -bang Q :q<bang>

" disable backups
set nobackup
set nowritebackup
set noundofile

" normal mode bindings
nnoremap <Enter> o<ESC>
nnoremap S i<Enter><ESC>
nnoremap <Backspace> i<Backspace><ESC>l
nnoremap <silent> gr :noh<Enter>
nnoremap gl $
nnoremap Y y$

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

" Split direction 
set splitbelow
set splitright

" Tab/split moving
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" enable autoswitching language
let g:XkbSwitchEnabled = 1

" NERDTree bind
nnoremap <silent> <C-n> :NERDTreeToggle<CR>

" Tag closing
let g:closetag_filenames = '*'
let g:closetag_filetypes = '*'
let g:closetag_shortcut = '>'
let g:closetag_emptyTags_caseSensitive = 1
nnoremap <silent> <leader>t :CloseTagToggleBuffer<CR>
autocmd BufNewFile,BufRead * :CloseTagDisableBuffer

" Auto-pairs toggling
let g:AutoPairsShortcutToggle = '<leader>P'

" Nerd commenter
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'
let g:NERDTrimTrailingWhitespace = 1
let g:NERDToggleCheckAllLines = 1
nmap <C-_> <plug>NERDCommenterInvert
vmap <C-_> <plug>NERDCommenterInvert
imap <C-_> <plug>NERDCommenterInsert

" python pep8 indentations
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

" vimpy
autocmd BufNewFile,BufRead *.py nnoremap <leader>v :VimpyCheckLine<CR>

" jedi-vim
let g:jedi#force_py_version = 3
let g:jedi#use_splits_not_buffers = "left"
autocmd FileType python setlocal completeopt-=preview

" ale
let g:ale_set_highlights = 0
let g:ale_fixers = {'python': ['autopep8', 'isort']}
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
autocmd BufNewFile,BufRead *.py nmap <silent> <C-[> <Plug>(ale_previous_wrap)
autocmd BufNewFile,BufRead *.py nmap <silent> <C-]> <Plug>(ale_next_wrap)
autocmd BufNewFile,BufRead *.py nnoremap <leader>l :ALELint<CR>
autocmd BufNewFile,BufRead *.py nnoremap <leader>f :ALEFix<CR>
" ----
autocmd BufNewFile,BufRead * :ALEDisable
autocmd BufNewFile,BufRead * nnoremap <leader>L :ALEToggle<CR>

" supertab
let b:SuperTabDisabled = 1
autocmd BufNewFile,BufRead *.py let b:SuperTabDisabled = 0

" custom python hotkeys
autocmd BufNewFile,BufRead *.py nnoremap <leader>e :w <bar> :echo system('python "' . expand('%') . '"')<cr>
autocmd BufNewFile,BufRead *.py nnoremap <leader>E :w <bar> :!python %<cr>
autocmd BufNewFile,BufRead *.py nnoremap <leader>b ifrom<Space>pdb<Space>import<Space>set_trace;<Space>set_trace()<Tab>#<Space>BREAKPOINT<ESC>
