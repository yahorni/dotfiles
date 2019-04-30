set nocompatible

call plug#begin('~/.vim/plugged')

" file picker
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'qpkorr/vim-bufkill'

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
Plug 'Shougo/neoinclude.vim'

" snippets
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'honza/vim-snippets'

" i3
Plug 'PotatoesMaster/i3-vim-syntax'

" latex
Plug 'lervag/vimtex'

" markdown
Plug 'vim-pandoc/vim-pandoc-syntax'

" linting
Plug 'w0rp/ale'

" python
Plug 'vim-scripts/indentpython.vim'
Plug 'zchee/deoplete-jedi'
Plug 'davidhalter/jedi-vim'

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

" c++
Plug 'zchee/deoplete-clang'
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'uplus/vim-clang-rename'

" tags
Plug 'majutsushi/tagbar'

" html
Plug 'mattn/emmet-vim'
Plug 'othree/html5.vim'

" wal colorscheme
Plug 'dylanaraps/wal.vim'

" indentation
Plug 'Yggdroot/indentLine'

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
    Plug 'dracula/vim', { 'as': 'dracula' }
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
set nolist

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
" colo wal
if (&term!='linux')
    " different cursors per mode
    let &t_SI = "\<Esc>[6 q"
    let &t_SR = "\<Esc>[4 q"
    let &t_EI = "\<Esc>[2 q"

    " colorscheme
    au FileType python,go,c,cpp,javascript let g:gruvbox_contrast_dark='hard' | colo gruvbox
    au FileType tex,markdown.pandoc,html,css colo dracula
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
    if !exists('b:SplitResizing')
        let b:SplitResizing=1
        echo "Resizing enabled"
    else
        unlet b:SplitResizing
        echo "Resizing disabled"
    endif
endfun

nnoremap <silent> <expr> <ESC> exists('b:SplitResizing') ? '<ESC>:unlet b:SplitResizing<CR>:echo "Resizing disabled"<CR>' : '<ESC>'
nnoremap <silent> <expr> <C-H> !exists('b:SplitResizing') ? '<C-W><C-H>' : ':vert res -1<CR>'
nnoremap <silent> <expr> <C-J> !exists('b:SplitResizing') ? '<C-W><C-J>' : ':res -1<CR>'
nnoremap <silent> <expr> <C-K> !exists('b:SplitResizing') ? '<C-W><C-K>' : ':res +1<CR>'
nnoremap <silent> <expr> <C-L> !exists('b:SplitResizing') ? '<C-W><C-L>' : ':vert res +1<CR>'
nnoremap gs :call ToggleResizeSplitMode()<CR>

" buffer manipulation
nnoremap <silent> g<S-k> :bprev<CR>
nnoremap <silent> g<S-j> :bnext<CR>
nnoremap <silent> g<S-h> :bfirst<CR>
nnoremap <silent> g<S-l> :blast<CR>

if has("nvim")
    nnoremap <silent> <S-Tab> :bnext<CR>
endif

" file executing
nn <leader>e :w <bar> :!compiler %<CR>
nn <leader>E :w <bar> :!compiler %<SPACE>
nn <leader>p :!opout %<CR><CR>

au FileType tex nn <leader>c :w <bar> :!pdflatex %<CR>
au FileType tex nn <leader>C :!texclear %:p:h<CR><CR>

" couple math snippets for latex
au FileType tex ino <leader><leader>p \partial
au FileType tex ino <leader><leader>d \displaystyle

" enable pandoc markdown syntax
au FileType markdown set filetype=markdown.pandoc
au VimEnter *.md set filetype=markdown

" calcurse notes as markdown
au BufRead,BufNewFile,VimEnter /tmp/calcurse* set filetype=markdown
au BufRead,BufNewFile,VimEnter ~/.calcurse/notes/* set filetype=markdown

" systemd service files
au BufRead,BufNewFile *.service set filetype=dosini

" python pep textwidth
au FileType python set textwidth=79

" c++ style
au FileType c,cpp,javascript
            \ set tabstop=2 |
            \ set shiftwidth=2

" enable autoswitching language
let g:XkbSwitchEnabled = 1

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
au BufNewFile,BufRead *.html,*.xml,*.ejs :CloseTagEnableBuffer<CR>

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
let g:SuperTabDefaultCompletionType = "<c-n>"

" deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1

" deoplete-clang
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so.8'
let g:deoplete#sources#clang#clang_header = '/usr/lib/clang/'

" jedi
if !has('nvim')
    let g:jedi#auto_initialization = 0
    au FileType python |
                \ let g:jedi#auto_initialization = 1 |
                \ let g:jedi#force_py_version = 3 |
                \ let g:jedi#use_splits_not_buffers = "left" |
                \ let g:jedi#show_call_signatures = 2 |
                \ let g:jedi#popup_select_first = 0
    au FileType python call jedi#configure_call_signatures()
endif

" ale
let g:ale_fixers = {
            \   '*': ['remove_trailing_lines', 'trim_whitespace'],
            \   'python': ['autopep8', 'isort', 'black'],
            \   'javascript': ['prettier'],
            \}
let g:ale_linters = {
            \   'python': ['flake8', 'pylint'],
            \   'tex': ['chktex'],
            \   'cpp': ['cppcheck', 'clang', 'gcc'],
            \   'c': ['clang', 'gcc'],
            \   'html': ['tidy'],
            \   'css': ['stylelint', 'prettier'],
            \}
let g:ale_set_highlights = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_completion_enabled = 0
let b:ale_list_window_size = 5
let b:ale_warn_about_trailing_blank_lines = 1
let b:ale_warn_about_trailing_whitespace = 1
au FileType cpp,go,python setlocal completeopt-=preview
nnoremap <leader>l :ALELint<CR>
nnoremap <leader>f :ALEFix<CR>
nnoremap <leader>L :ALEToggle<CR>

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

" vim-go
au FileType go let g:go_fmt_fail_silently = 1
au FileType go let g:SuperTabDefaultCompletionType = "context"
au FileType go call deoplete#custom#buffer_option('auto_complete', v:false)

" neosnippet
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
            \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" fuzzy finder
nnoremap <silent> <C-W>b :Buffers<CR>

" tagbar
nnoremap <silent> <C-W>t :TagbarToggle<CR>

" c++
au FileType c,cpp AutoFormatBuffer clang-format
au FileType c,cpp nmap <buffer><silent> <leader>r <Plug>(clang_rename-current)

" emmet
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall

" json format
" au BufWritePre *.json :%!jq '.'
au FileType javascript noremap <buffer>  <c-f> :call JsBeautify()<cr>
" for json
au FileType json noremap <buffer> <c-f> :call JsonBeautify()<cr>
" for jsx
au FileType jsx noremap <buffer> <c-f> :call JsxBeautify()<cr>
" for html
au FileType html noremap <buffer> <c-f> :call HtmlBeautify()<cr>
" for css or scss
au FileType css noremap <buffer> <c-f> :call CSSBeautify()<cr>

" shfmt
au FileType sh noremap <buffer> <c-f> :%!shfmt<cr>
