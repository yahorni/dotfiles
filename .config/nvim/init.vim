set nocompatible

" set leader key
let mapleader=" "

call plug#begin('~/.vim/plugged')

" buffer manipulation
Plug 'rbgrouleff/bclose.vim'

" comments
Plug 'scrooloose/nerdcommenter'
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'
let g:NERDTrimTrailingWhitespace = 1
let g:NERDToggleCheckAllLines = 1
let g:NERDCustomDelimiters = {'': {'left': '#','right': '' }}
if (&term!='linux')
    nmap <C-_> <plug>NERDCommenterInvert<ESC>j0
    vmap <C-_> <plug>NERDCommenterInvert<ESC>j0
    imap <C-_> <plug>NERDCommenterInsert
else
    nmap <C-c> <plug>NERDCommenterInvert<ESC>j0
    vmap <C-c> <plug>NERDCommenterInvert<ESC>j0
    imap <C-c> <plug>NERDCommenterInsert
endif

" improved quoting/parenthesizing
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat' " dot command for vim-surround
Plug 'jiangmiao/auto-pairs'
let g:AutoPairsShortcutToggle = ''

" highlight for substituion
Plug 'markonm/traces.vim'

" rename file
Plug 'vim-scripts/Rename2'

" search with ripgrep
Plug 'jremmen/vim-ripgrep'

" status line
Plug 'itchyny/lightline.vim'

" autocomplete
Plug 'ervandew/supertab'
let g:SuperTabDefaultCompletionType = "<C-n>"
Plug 'Shougo/deoplete.nvim'
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
Plug 'Shougo/neoinclude.vim'

" snippets
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'honza/vim-snippets'
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets,~/.vim/snippets'
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
            \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" linting
Plug 'w0rp/ale'
let g:ale_fixers = {
            \   '*': ['remove_trailing_lines', 'trim_whitespace'],
            \   'python': ['autopep8', 'isort', 'black'],
            \   'cpp': ['clangtidy'],
            \   'c': ['clangtidy'],
            \   'sh': ['shellcheck'],
            \}
let g:ale_linters = {
            \   'python': ['flake8', 'pylint'],
            \   'tex': ['chktex'],
            \   'cpp': ['clang', 'gcc'],
            \   'c': ['clang', 'gcc'],
            \   'sh': ['shfmt'],
            \}
let g:ale_c_parse_compile_commands = 1 " cpp headers issue

let g:ale_set_highlights = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_completion_enabled = 0
let b:ale_list_window_size = 5
let b:ale_warn_about_trailing_blank_lines = 1
let b:ale_warn_about_trailing_whitespace = 1
au FileType cpp,go,python setlocal completeopt-=preview
nn <silent> <leader>F :ALEFix<CR>
nn <silent> <leader>L :ALEToggle<CR>
nn <silent> <A-[> :ALEPrevious<CR>
nn <silent> <A-]> :ALENext<CR>

" python
Plug 'vim-scripts/indentpython.vim'
Plug 'davidhalter/jedi-vim'
Plug 'zchee/deoplete-jedi'
if has('nvim')
    let g:jedi#completions_enabled = 0
endif
let g:jedi#force_py_version = 3
let g:jedi#use_splits_not_buffers = "left"
let g:jedi#show_call_signatures = 2
let g:jedi#popup_select_first = 0

" go
Plug 'fatih/vim-go'
au FileType go let g:go_fmt_fail_silently = 1
au FileType go call deoplete#custom#buffer_option('auto_complete', v:false)
au FileType go let g:SuperTabDefaultCompletionType = "context"

" fzf
Plug '/usr/bin/fzf'
Plug 'junegunn/fzf.vim'
nn <silent> <C-b> :Buffers<CR>
nn <silent> <leader>b :FZF<CR>

" c++
Plug 'zchee/deoplete-clang'
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/lib/clang/'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'rhysd/vim-clang-format'
let g:clang_format#code_style = 'llvm'
au FileType c,cpp,h,hpp nn <silent> <C-f> :ClangFormat<CR>
Plug 'uplus/vim-clang-rename'
au FileType c,cpp,h,hpp nn <silent> <leader>r :ClangRenameCurrent<CR>
Plug 'derekwyatt/vim-fswitch'
au FileType c,cpp,h,hpp nn <silent> <leader>o :FSHere<CR>

" tagbar
Plug 'majutsushi/tagbar'
nn <silent> <leader>t :TagbarToggle<CR>

" indentation
Plug 'Yggdroot/indentLine'
" can break conceallevel
au FileType tex,markdown,json let g:indentLine_setColors = 0
au FileType tex,markdown,json let g:indentLine_enabled = 0

" language switching
Plug 'lyokha/vim-xkbswitch'
let g:XkbSwitchEnabled = 1

"highlight hex colors
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
let g:Hexokinase_highlighters = ['backgroundfull']

" theme
Plug 'drewtempelmeyer/palenight.vim'

" SYNTAX FILES
Plug 'vifm/vifm.vim'                " vifm
Plug 'baskerville/vim-sxhkdrc'      " sxhkd
Plug 'tomlion/vim-solidity'         " solidity
Plug 'vim-pandoc/vim-pandoc-syntax' " markdown
au FileType markdown setlocal filetype=markdown.pandoc
au VimEnter *.md setlocal filetype=markdown
let g:pandoc#syntax#conceal#use = 0

call plug#end()

filetype plugin on

" file manager
let g:netrw_banner = 0
let g:netrw_liststyle = 3
nn <silent> <C-n> :Explore<CR>
nn <silent> <leader>n :Rexplore<CR>
nn <silent> <leader>_ <Plug>NetrwRefresh

" theme
set bg=dark
colo palenight
hi Normal ctermbg=233

set laststatus=2
set ffs=unix,dos,mac
set encoding=utf-8
set fencs=utf-8,cp1251,koi8-r,ucs-2,cp866
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
set modeline
set modelines=5
set noshowmode
set showcmd
set wildmenu
set wildmode=longest,list,full
set mouse=a
set scrolloff=5
set foldmethod=indent
set foldlevel=99
set splitbelow
set splitright
set fileformat=unix
set nolist
set conceallevel=0
set concealcursor=nvic
set cursorline
set cino=N-s,g0
set tags=./tags;
set termguicolors

" change <paste> command behaviour
xn p "_dp
xn P "_dP

" disable Ex mode
nn Q <nop>

" annoying keys
com! Q :q
com! W :w
com! WQ :wq
com! Wq :wq
com! -bang Q :q<bang>

" normal mode bindings
nn <silent> <leader>f :noh<Enter>
nn Y y$
nn zq ZQ

" buffer switching
nn <silent> <leader>h :bprev<CR>
nn <silent> <leader>l :bnext<CR>
nn <silent> <C-q> :close<CR>

" different cursors per mode
if (&term!='linux')
    if exists('$TMUX')
        let &t_SI = "\ePtmux;\e\e[6 q\e\\"
        let &t_SR = "\ePtmux;\e\e[4 q\e\\"
        let &t_EI = "\ePtmux;\e\e[2 q\e\\"
    else
        let &t_SI = "\e[6 q"
        let &t_SR = "\e[4 q"
        let &t_EI = "\e[2 q"
    endif
endif

" Split moving/resizing
fun! ToggleResizeSplitMode()
    if !exists('b:SplitResize')
        let b:SplitResize=1
        echo "Resizing enabled"
    else
        unlet b:SplitResize
        echo "Resizing disabled"
    endif
endfun

nn <silent> <expr> <C-h> !exists('b:SplitResize') ? '<C-w><C-h>' : ':vert res -1<CR>'
nn <silent> <expr> <C-j> !exists('b:SplitResize') ? '<C-w><C-j>' : ':res -1<CR>'
nn <silent> <expr> <C-k> !exists('b:SplitResize') ? '<C-w><C-k>' : ':res +1<CR>'
nn <silent> <expr> <C-l> !exists('b:SplitResize') ? '<C-w><C-l>' : ':vert res +1<CR>'
 " it's better to not remap ESC button
nn gr :call ToggleResizeSplitMode()<CR>

" file executing
nn <leader>e :w <bar> :!compiler %<CR>
nn <leader>E :w <bar> :!compiler % 2<CR>
nn <leader>x :!chmod +x %<CR>
nn <leader>X :!chmod -x %<CR>

" showing results
au FileType tex,markdown nn <leader>p :!opout %<CR><CR>
au FileType c,cpp nn <leader>p :!./%:r<CR>

au FileType tex nn <leader>c :!texclear %:p:h<CR><CR>
au VimLeave *.tex !texclear %:p:h

" STYLES
" python pep textwidth
au FileType python setlocal textwidth=79 | setlocal colorcolumn=80
" c++ style
au FileType c,cpp,h,hpp setlocal tabstop=4 | setlocal shiftwidth=4 |
            \ setlocal textwidth=120 | setlocal colorcolumn=121
" js style
au FileType javascript setlocal tabstop=2 | setlocal shiftwidth=2

" FORMATTERS
" shell
au FileType sh nn <buffer> <C-f> :%!shfmt<CR>
" json
au FileType json nn <buffer> <C-f> :%!jq<CR>

" TABS
nn <silent> th :tabprev<CR>
nn <silent> tl :tabnext<CR>
nn <silent> tn :tabnew<CR>
nn <silent> tc :tabclose<CR>

" Autoremove trailing whitespaces
nn <silent> <leader>w :%s/\s\+$//e <bar> nohl<CR>

" Update ctags
com Ctags execute "!ctags -R --exclude=.git --exclude=node_modules ."
nn <silent> <leader>T :Ctags<CR>
