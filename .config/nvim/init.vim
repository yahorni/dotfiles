set nocompatible

call plug#begin('~/.vim/plugged')

" file picker
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'

" comments
Plug 'scrooloose/nerdcommenter'

" git
Plug 'tpope/vim-fugitive'

" improved quoting/parenthesizing
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'alvan/vim-closetag'

" highlight for substituion
Plug 'markonm/traces.vim'

" status line
Plug 'vim-airline/vim-airline'

" autocomplete
Plug 'ervandew/supertab'
Plug 'Shougo/deoplete.nvim'

" snippets
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

" i3
Plug 'PotatoesMaster/i3-vim-syntax'

" latex
Plug 'lervag/vimtex'

" markdown
Plug 'vim-pandoc/vim-pandoc-syntax'

" python
Plug 'vim-scripts/indentpython.vim'
Plug 'davidhalter/jedi-vim'
Plug 'w0rp/ale'
Plug 'zchee/deoplete-jedi'

" go
Plug 'fatih/vim-go'

" fzf
Plug '/usr/bin/fzf'
Plug 'junegunn/fzf.vim'

" vifm
Plug 'vifm/vifm.vim'

" js
Plug 'pangloss/vim-javascript'
Plug 'maksimr/vim-jsbeautify'

if (&term!='linux')
	" language switching
	Plug 'lyokha/vim-xkbswitch'

	" nerdtree unicode git symbols
	Plug 'Xuyuanp/nerdtree-git-plugin'

	"highlight hex colors
	Plug 'lilydjwg/colorizer'

	" theme
	Plug 'morhetz/gruvbox'
	Plug 'crusoexia/vim-monokai'
	Plug 'vim-airline/vim-airline-themes'
endif

call plug#end()

filetype plugin on
set laststatus=0
set encoding=utf-8
set autoindent
set incsearch
set hlsearch
set hidden
set viminfo="-"
set clipboard=unnamedplus
set expandtab
set tabstop=4
set shiftwidth=4
set smarttab
set number
set relativenumber
set nobackup
set nowritebackup
set noundofile
set bg=dark
set modeline
set modelines=5
set noshowmode
set showcmd
set conceallevel=2
set wildmenu
set wildmode=longest,list,full
set mouse=a
set scrolloff=5
set foldmethod=indent
set foldlevel=99
set splitbelow
set splitright
set fileformat=unix

" change <paste> command behaviour
xnoremap p "_dp
xnoremap P "_dP

" disable Ex mode
nnoremap Q <nop>

" annoying keys
command! Q :q
command! W :w
command! WQ :wq
command! Wq :wq
command! -bang Q :q<bang>

" normal mode bindings
nnoremap <silent> gr :noh<Enter>
nnoremap Y y$

" moving in insert mpde
inoremap <C-H> <Left>
inoremap <C-L> <Right>

" theme
colo ron
if (&term!='linux')
	" different cursors per mode
	let &t_SI = "\<Esc>[6 q"
	let &t_SR = "\<Esc>[4 q"
	let &t_EI = "\<Esc>[2 q"

	" colorscheme
	au FileType python,go let g:gruvbox_contrast_dark='hard' | colo gruvbox
	au FileType tex,markdown.pandoc colo monokai
endif

" Split moving/resizing
fun! ToggleResizeSplitMode()
	if !exists('b:SplitResizing')
		let b:SplitResizing=1
		echo "Resizing enabled"
	else
		unlet b:SplitResizing
		echo "Resizing disabled"
	endif
endfun

nnoremap <silent> <expr> <ESC> exists('b:SplitResizing') ? '<ESC>:unlet b:SplitResizing<CR><ESC>' : '<ESC>'
nnoremap <silent> <expr> <C-H> !exists('b:SplitResizing') ? '<C-W><C-H>' : ':vert res -1<CR>'
nnoremap <silent> <expr> <C-J> !exists('b:SplitResizing') ? '<C-W><C-J>' : ':res -1<CR>'
nnoremap <silent> <expr> <C-K> !exists('b:SplitResizing') ? '<C-W><C-K>' : ':res +1<CR>'
nnoremap <silent> <expr> <C-L> !exists('b:SplitResizing') ? '<C-W><C-L>' : ':vert res +1<CR>'
nnoremap gs :call ToggleResizeSplitMode()<CR>

" tab manipulation
nnoremap <silent> th :bprev<CR>
nnoremap <silent> tl :bnext<CR>
nnoremap <silent> t<S-h> :bfirst<CR>
nnoremap <silent> t<S-l> :blast<CR>

" file executing
nn <leader>e :w <bar> :!compiler %<CR>
nn <leader>E :w <bar> :!compiler %<SPACE>
nn <leader>p :!opout %<CR><CR>

" couple math snippets for latex
au FileType tex ino <leader><leader>p \partial
au FileType tex ino <leader><leader>d \displaystyle

augroup calcurse
	au BufRead,BufNewFile /tmp/calcurse* set filetype=markdown
	au BufRead,BufNewFile ~/.calcurse/notes/* set filetype=markdown
augroup END

augroup systemd
	au BufRead,BufNewFile *.service set filetype=dosini
augroup END

" enable pandoc markdown syntax
au FileType markdown set filetype=markdown.pandoc

" enable autoswitching language
let g:XkbSwitchEnabled = 1

" goyo toggle
nnoremap <silent> <leader>g :Goyo<CR>

" NERDTree bind
let NERDTreeShowHidden = 1
nnoremap <silent> <C-N> :NERDTreeTabsToggle<CR>

" Tag closing
let g:closetag_filenames = '*'
let g:closetag_filetypes = '*'
let g:closetag_shortcut = '>'
let g:closetag_emptyTags_caseSensitive = 1
nnoremap <silent> <leader>t :CloseTagToggleBuffer<CR>
au BufNewFile,BufRead * :CloseTagDisableBuffer<CR>

" Auto-pairs toggling (brackets)
let g:AutoPairsShortcutToggle = '<leader>P'

" Nerd commenter
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'
let g:NERDTrimTrailingWhitespace = 1
let g:NERDToggleCheckAllLines = 1
if (&term!='linux')
	nmap <C-_> <plug>NERDCommenterInvert<ESC>j0
	vmap <C-_> <plug>NERDCommenterInvert<ESC>j0
	imap <C-_> <plug>NERDCommenterInsert
else
	nmap <C-c> <plug>NERDCommenterInvert<ESC>j0
	vmap <C-c> <plug>NERDCommenterInvert<ESC>j0
	imap <C-c> <plug>NERDCommenterInsert
endif

" colorizer
let g:colorizer_maxlines = 1000

" supertab
let g:SuperTabDefaultCompletionType = 'context'

" deoplete
let g:deoplete#enable_at_startup = 0

" jedi
let g:jedi#auto_initialization = 0

" ale
let g:ale_fixers = {
\	'*': ['remove_trailing_lines', 'trim_whitespace'],
\	'python': ['autopep8', 'isort', 'black'],
\}
let g:ale_linters = {
\	'python': ['flake8', 'pylint'],
\   'tex': ['chktex'],
\}

" airline
let g:airline_exclude_filetypes = ['text']
let g:airline#extensions#whitespace#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_alt_sep = '|'
if (&term!='linux')
	let g:airline_theme='minimalist'
	let g:airline#extensions#xkblayout#enabled = 1
	let g:airline_powerline_fonts = 1
	let g:airline_extensions = ['tabline', 'ale', 'branch', 'vimtex', 'whitespace', 'xkblayout']
	let g:airline#extensions#tabline#left_sep = ' '
else
	let g:airline_powerline_fonts = 0
	let g:airline_extensions = ['tabline', 'ale', 'branch', 'vimtex', 'whitespace']
	let g:airline#extensions#tabline#left_sep = '>'
endif

augroup pycommands
	au FileType python set textwidth=79

	au FileType python
		\ let g:jedi#auto_initialization = 1 |
		\ let g:jedi#force_py_version = 3 |
		\ let g:jedi#use_splits_not_buffers = "left" |
		\ let g:jedi#show_call_signatures = 2 |
		\ let g:jedi#popup_select_first = 0
	au FileType python setlocal completeopt-=preview

	if !has('nvim')
		au FileType python call jedi#configure_call_signatures()
	else
		au FileType python |
			\ set rtp+=~/.vim/bundle/deoplete.nvim/ |
			\ let g:deoplete#enable_at_startup = 1
	endif

	au FileType python,tex
		\ let b:ale_set_highlights = 1 |
		\ let b:ale_lint_on_text_changed = 'never' |
		\ let b:ale_lint_on_enter = 0 |
		\ let b:ale_completion_enabled = 0 |
		\ let b:ale_list_window_size = 5 |
		\ let b:ale_warn_about_trailing_blank_lines = 1 |
		\ let b:ale_warn_about_trailing_whitespace = 1
	au FileType python,tex nnoremap <leader>l :ALELint<CR>
	au FileType python,tex nnoremap <leader>f :ALEFix<CR>
	au FileType python,tex nnoremap <leader>L :ALEToggle<CR>
augroup END

" vim-go
let g:go_fmt_fail_silently = 1
au FileType go setlocal completeopt-=preview

" neosnippet
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
