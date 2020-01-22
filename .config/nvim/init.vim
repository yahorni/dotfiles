set nocompatible

call plug#begin('~/.vim/plugged')

" buffer manipulation
Plug 'scrooloose/nerdtree'
nnoremap <silent> <C-N> :NERDTreeToggle<CR>
Plug 'qpkorr/vim-bufkill'

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

" git
Plug 'tpope/vim-fugitive'
nn gdd :Gvdiffsplit!<CR>
nn gdh :diffget //2<CR>
nn gdl :diffget //3<CR>

" improved quoting/parenthesizing
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat' " dot command for vim-surround
Plug 'jiangmiao/auto-pairs'
let g:AutoPairsShortcutToggle = '<A-P>'
Plug 'alvan/vim-closetag'
let g:closetag_filenames = '*'
let g:closetag_filetypes = '*'
let g:closetag_shortcut = '>'
let g:closetag_emptyTags_caseSensitive = 1
nnoremap <silent> <leader>t :CloseTagToggleBuffer<CR>
au BufNewFile,BufRead * :CloseTagDisableBuffer<CR>
au BufNewFile,BufRead *.html,*.xml :CloseTagEnableBuffer<CR>

" highlight for substituion
Plug 'markonm/traces.vim'

" status line
Plug 'vim-airline/vim-airline'
let g:airline_exclude_filetypes = ['text']
let g:airline#extensions#whitespace#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#left_sep = ''
if (&term!='linux')
    let g:airline_theme='minimalist' "hybrid
    let g:airline#extensions#xkblayout#enabled = 1
    let g:airline_powerline_fonts = 1
    let g:airline_extensions = ['tabline', 'ale', 'branch', 'vimtex', 'whitespace', 'xkblayout']
else
    let g:airline_powerline_fonts = 0
    let g:airline_extensions = ['tabline', 'ale', 'branch', 'vimtex', 'whitespace']
endif

" autocomplete
Plug 'ervandew/supertab'
let g:SuperTabDefaultCompletionType = "<c-n>"
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

" i3
Plug 'PotatoesMaster/i3-vim-syntax'

" latex
Plug 'lervag/vimtex'
let g:tex_flavor = 'latex'
let g:tex_conceal = 'abdmg'

" markdown
Plug 'vim-pandoc/vim-pandoc-syntax'
au FileType markdown set filetype=markdown.pandoc
au VimEnter *.md set filetype=markdown
let g:pandoc#syntax#conceal#use = 1

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
            \   'cpp': ['clangtidy', 'clangcheck', 'cppcheck',  'cpplint', 'clang', 'gcc'],
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
nn <silent> <leader>l :ALELint<CR>
nn <silent> <leader>f :ALEFix<CR>
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
nnoremap <silent> <C-b> :Buffers<CR>

" vifm
Plug 'vifm/vifm.vim'

" sxhkd
Plug 'baskerville/vim-sxhkdrc'

" c++
" au FileType cpp,c,h let g:SuperTabDefaultCompletionType = <c-x><c-i>
Plug 'zchee/deoplete-clang'
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/lib/clang/'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
au FileType c,cpp,h AutoFormatBuffer clang-format
Plug 'uplus/vim-clang-rename'
au FileType c,cpp,h nn <leader>r :ClangRename<CR>
Plug 'derekwyatt/vim-fswitch'
au FileType c,cpp,h nn <silent> <A-o> :FSHere<CR>
au FileType c,cpp,h ino <silent> <A-o> <ESC>:FSHere<CR>

" tags
Plug 'majutsushi/tagbar'
nnoremap <silent> <C-T> :TagbarToggle<CR>

" wal colorscheme
Plug 'dylanaraps/wal.vim'

" indentation
Plug 'Yggdroot/indentLine'
" can break conceallevel
au FileType tex,markdown,json let g:indentLine_setColors = 0
au FileType tex,markdown,json let g:indentLine_enabled = 0

" solidity
Plug 'tomlion/vim-solidity'

if (&term!='linux')
    " language switching
    Plug 'lyokha/vim-xkbswitch'
    let g:XkbSwitchEnabled = 1

    " nerdtree unicode git symbols
    Plug 'Xuyuanp/nerdtree-git-plugin'

    "highlight hex colors
    Plug 'lilydjwg/colorizer'
    let g:colorizer_maxlines = 1000

    " theme
    Plug 'vim-airline/vim-airline-themes'
    Plug 'drewtempelmeyer/palenight.vim'

endif

call plug#end()

filetype plugin on

set bg=dark
if (&bg=='dark')
    colo palenight
    hi Normal ctermbg=233
endif

set laststatus=0
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

" custom exit keys
nn zq ZQ

" normal mode bindings
nnoremap <silent> <C-x> :noh<Enter>
nnoremap Y y$

" moving in insert mpde
inoremap <C-H> <Left>
inoremap <C-L> <Right>

" buffer manipulation
nnoremap <silent> <C-s> :bprev<CR>
nnoremap <silent> <C-w> :bnext<CR>

" line movements
nnoremap <A-s> gj
nnoremap <A-w> gk

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

" Tab highlighting"
fun! ToggleTabHighlight()
    if !exists('b:TabHighlight')
        let b:TabHighlight=1
        set list lcs=tab:▷—,trail:○
        echo "Tab highlight enabled"
    else
        unlet b:TabHighlight
        set nolist
        echo "Tab highlight disabled"
    endif
endfun

nnoremap gS :call ToggleTabHighlight()<CR>

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

nn <silent> <expr> <ESC> exists('b:SplitResize') ? '<ESC>:unlet b:SplitResize<CR>:echo "Resizing disabled"<CR>' : '<ESC>'
nn <silent> <expr> <C-H> !exists('b:SplitResize') ? '<C-W><C-H>' : ':vert res -1<CR>'
nn <silent> <expr> <C-J> !exists('b:SplitResize') ? '<C-W><C-J>' : ':res -1<CR>'
nn <silent> <expr> <C-K> !exists('b:SplitResize') ? '<C-W><C-K>' : ':res +1<CR>'
nn <silent> <expr> <C-L> !exists('b:SplitResize') ? '<C-W><C-L>' : ':vert res +1<CR>'
nn gr :call ToggleResizeSplitMode()<CR>

" file executing
nn <leader>e :w <bar> :!compiler %<CR>
nn <leader>E :w <bar> :!compiler % 2<CR>
nn <leader>x :!chmod +x %<CR>

" showing results
au FileType tex,markdown nn <leader>p :!opout %<CR><CR>
au FileType c,cpp nn <leader>p :!./%:r<CR>

au FileType tex nn <leader>c :!texclear %:p:h<CR><CR>
au VimLeave *.tex !texclear %:p:h

" calcurse notes as markdown
au BufRead,BufNewFile,VimEnter /tmp/calcurse* set filetype=markdown.pandoc
au BufRead,BufNewFile,VimEnter ~/.calcurse/notes/* set filetype=markdown.pandoc

" systemd service files
au BufRead,BufNewFile *.service set filetype=dosini

" python pep textwidth
au FileType python set textwidth=79

" c++ style
au FileType c,cpp,javascript set tabstop=2 | set shiftwidth=2

" shfmt
au FileType sh nn <buffer> <c-f> :%!shfmt<cr>

" format json
au FileType json nn <buffer> <c-f> :%!python -m json.tool<cr>
