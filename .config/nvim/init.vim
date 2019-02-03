set nocompatible

call plug#begin('~/.vim/plugged')

Plug 'jiangmiao/auto-pairs'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'junegunn/goyo.vim'
Plug 'lyokha/vim-xkbswitch'
Plug 'markonm/traces.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'

if (&term!='linux')
	Plug 'Xuyuanp/nerdtree-git-plugin'
	Plug 'lilydjwg/colorizer'

	" theme
	Plug 'morhetz/gruvbox'
	Plug 'crusoexia/vim-monokai'
	Plug 'vim-airline/vim-airline-themes'
endif

" autocomplete
Plug 'ervandew/supertab'
Plug 'Shougo/deoplete.nvim'

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

" xml, html
Plug 'alvan/vim-closetag'

" vifm
Plug 'vifm/vifm.vim'

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
set modelines=2
set noshowmode
set showcmd
set conceallevel=2
set wildmenu
set wildmode=longest,list,full
set mouse=a

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
" nnoremap <Enter> o<ESC>
" nnoremap S i<Enter><ESC>
" nnoremap <Backspace> i<Backspace><ESC>l
nnoremap <silent> gr :noh<Enter>
nnoremap gl $
nnoremap Y y$

" moving in insert mpde
inoremap <C-H> <Left>
inoremap <C-L> <Right>

if (&term!='linux')
	" different cursors per mode
	let &t_SI = "\<Esc>[6 q"
	let &t_SR = "\<Esc>[4 q"
	let &t_EI = "\<Esc>[2 q"

	" colorscheme
	colo ron
	au FileType python let g:gruvbox_contrast_dark='hard' | colo gruvbox
	au FileType tex,markdown colo monokai
endif

" folding
set foldmethod=indent
set foldlevel=99
nnoremap <space> za

" Split direction
set splitbelow
set splitright

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

nnoremap <silent> <expr> <C-H> !exists('b:SplitResizing') ? '<C-W><C-H>' : ':vert res -1<CR>'
nnoremap <silent> <expr> <C-J> !exists('b:SplitResizing') ? '<C-W><C-J>' : ':res -1<CR>'
nnoremap <silent> <expr> <C-K> !exists('b:SplitResizing') ? '<C-W><C-K>' : ':res +1<CR>'
nnoremap <silent> <expr> <C-L> !exists('b:SplitResizing') ? '<C-W><C-L>' : ':vert res +1<CR>'
nnoremap gs :call ToggleResizeSplitMode()<CR>

" bash script execution
augroup shexec
	au FileType sh nn <leader>e :w <bar> :echo system('./"' . expand('%') . '"')<cr>
	au FileType sh nn <leader>E :w <bar> :! ./% >/tmp/vim_sh.txt<cr> :new /tmp/vim_sh.txt<cr>
	au FileType sh nn <leader>a :w <bar> :! ./%
augroup END

" groff
augroup groff_compile
	au FileType nroff com! GroffCompile !groff -ms % -T pdf -t > %:r.pdf
	au FileType nroff nn <silent> <leader>e :w <bar> :GroffCompile<cr>
augroup END

" latex
augroup tex_compile
	au FileType tex com! TexCompile !pdflatex %
	au FileType tex nn <silent> <leader>e :w <bar> :TexCompile<cr>

	au FileType tex ino <leader><leader>f \frac{}<ESC>i
	au FileType tex ino <leader><leader>p \partial
	au FileType tex ino <leader><leader>b \begin{}<ESC>i
	au FileType tex ino <leader><leader>d \displaystyle
	au FileType tex ino <leader><leader>l \left(
	au FileType tex ino <leader><leader>r \right)
augroup END

" markdown
augroup md_compile
	au FileType markdown com! MdCompile !pandoc % --pdf-engine=xelatex -V mainfont="DejaVu Sans" -o %:r.pdf
	au FileType markdown nn <silent> <leader>e :MdCompile<cr>

	au FileType markdown com! PresCompile !pandoc % -V lang=ru -t beamer -o %:r.pdf
	au FileType markdown nn <silent> <leader>E :PresCompile<cr>

	au FileType markdown set filetype=markdown.pandoc
augroup END

" calcurse
augroup calcurse
	au BufRead,BufNewFile /tmp/calcurse* set filetype=markdown
	au BufRead,BufNewFile ~/.calcurse/notes/* set filetype=markdown
augroup END

" systemd services
augroup systemd_syntax
	au BufRead,BufNewFile *.service set filetype=dosini
augroup END

" python script execution and debugging
augroup pyexec
	au FileType python nn <leader>e :w <bar> :echo system('python "' . expand('%') . '"')<cr>
	au FileType python nn <leader>E :w <bar> :!python % >/tmp/vim_py.txt<cr> :new /tmp/vim_py.txt<cr>
	au FileType python nn <leader>B :w <bar> :!pudb3 %<cr>

	" pep8
	au FileType python
		\ set tabstop=4 |
		\ set softtabstop=4 |
		\ set shiftwidth=4 |
		\ set textwidth=79 |
		\ set expandtab |
		\ set autoindent |
		\ set fileformat=unix
augroup END

augroup xresources
	au BufRead,BufNewFile ~/.Xresources nn <leader>e :w <bar> :!xrdb -merge %<cr>
augroup END

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

	au FileType python
		\ let b:ale_set_highlights = 1 |
		\ let b:ale_lint_on_text_changed = 'never' |
		\ let b:ale_lint_on_enter = 0 |
		\ let b:ale_completion_enabled = 0 |
		\ let b:ale_list_window_size = 5 |
		\ let b:ale_warn_about_trailing_blank_lines = 1 |
		\ let b:ale_warn_about_trailing_whitespace = 1
	au FileType python nnoremap <leader>l :ALELint<CR>
	au FileType python nnoremap <leader>f :ALEFix<CR>
	au FileType python nnoremap <leader>L :ALEToggle<CR>
augroup END
