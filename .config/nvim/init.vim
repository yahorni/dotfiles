" vim: fdm=marker fdl=0 ts=2 sw=2 sts=2
set nocompatible

" set leader key
let mapleader=" "
let maplocalleader=","

" {{{ PLUGINS

call plug#begin('~/.vim/plugged')

" treeview
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-hijack.vim'
nn <silent> <C-n> :Fern . -reveal=%<CR>
nn <silent> <leader>n :Fern . -reveal=% -drawer -toggle<CR>
let g:fern#disable_default_mappings = 1
let g:fern#disable_viewer_hide_cursor = 1

function! FernInit() abort
  nmap <buffer><nowait> l <Plug>(fern-action-open-or-expand)
  nmap <buffer><nowait> h <Plug>(fern-action-collapse)
  nmap <buffer><nowait> s <Plug>(fern-action-open:split)
  nmap <buffer><nowait> v <Plug>(fern-action-open:vsplit)
  nmap <buffer> za <Plug>(fern-action-hidden-toggle)
endfunction

augroup FernGroup
  autocmd!
  autocmd FileType fern call FernInit()
augroup END

" buffer manipulation
Plug 'rbgrouleff/bclose.vim'
nn <silent> <leader>q :Bclose<CR>

" comments
Plug 'tpope/vim-commentary'
nmap <C-_> <plug>CommentaryLine<ESC>j
vmap <C-_> <plug>Commentary<ESC>

" improved quoting/parenthesizing
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat' " dot command for vim-surround
Plug 'jiangmiao/auto-pairs'
let g:AutoPairsShortcutToggle = ''

" highlight for substituion
Plug 'markonm/traces.vim'

" rename file
Plug 'vim-scripts/Rename2'

" status line
Plug 'itchyny/lightline.vim'

" autocomplete
Plug 'ervandew/supertab'
let g:SuperTabDefaultCompletionType = "context"

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
let g:ale_fixers = { '*': ['remove_trailing_lines', 'trim_whitespace'] }
let g:ale_linters = {
			\   'cpp': ['cpplint', 'clang', 'gcc'],
      \   'c': ['clang', 'gcc'],
      \   'sh': ['shfmt'],
      \   'python': ['flake8', 'pylint'],
      \   'tex': ['chktex'],
      \}
let g:ale_set_highlights = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let b:ale_list_window_size = 5
let g:ale_completion_enabled = 1
" tex options
" 13 - intersentence spacing
" 26 - spaces before punctuation
" 44 - hline in tables
let g:ale_tex_chktex_options = '-n13 -n26 -n44'
" c/c++ options
" NOTE: cpp headers issue
let g:ale_c_parse_compile_commands = 1
let g:ale_cpp_cpplint_options =
      \'--extensions=cpp,hpp,cc,c,h --filter=-legal/copyright,-build/include_order,
      \-whitespace/line_length,-whitespace/indent,-whitespace/comments,
      \-runtime/references,-readability/todo,-build/include'
set omnifunc=ale#completion#OmniFunc
nmap <leader>Al <Plug>(ale_lint)
nmap <leader>At <Plug>(ale_toggle)
nmap <leader>Af <Plug>(ale_fix)
nmap <leader>Ad <Plug>(ale_detail)
nmap <leader>]  <Plug>(ale_next)
nmap <leader>[  <Plug>(ale_previous)

" python
Plug 'vim-scripts/indentpython.vim'

" go
Plug 'fatih/vim-go'
au FileType go let g:go_fmt_fail_silently = 1

" fzf
Plug '/usr/bin/fzf'
Plug 'junegunn/fzf.vim'
nn <silent> <C-b> :Buffers<CR>
nn <silent> <leader>b :FZF<CR>

" c++
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'derekwyatt/vim-fswitch'
au FileType c,cpp,h,hpp nn <silent> <leader>s :FSHere<CR>
Plug 'rhysd/vim-clang-format'
au FileType c,h,cpp,hpp nn <buffer> <C-f> :ClangFormat<CR>

" tagbar
Plug 'majutsushi/tagbar'
" TODO: make focusable from any split
nn <silent> <leader>T :TagbarToggle<CR>

" indentation
Plug 'Yggdroot/indentLine' " can break conceallevel
au FileType tex,markdown,json let g:indentLine_setColors = 0
au FileType tex,markdown,json let g:indentLine_enabled = 0

" language switching
Plug 'lyokha/vim-xkbswitch'
let g:XkbSwitchEnabled = 1

" highlight colors
Plug 'ap/vim-css-color'

" syntax files
Plug 'baskerville/vim-sxhkdrc'      " sxhkd
Plug 'tomlion/vim-solidity'         " solidity
Plug 'vim-pandoc/vim-pandoc-syntax' " markdown
au FileType markdown setlocal filetype=markdown.pandoc
au VimEnter *.md setlocal filetype=markdown
let g:pandoc#syntax#conceal#use = 0

" file picker
Plug 'vifm/vifm.vim'

" theme
Plug 'arcticicestudio/nord-vim'
Plug 'morhetz/gruvbox'
Plug 'liuchengxu/space-vim-dark'

call plug#end()

filetype plugin on

" }}}

" {{{ COLORTHEME
" NOTE: term colors can break colorscheme in vanilla vim
"""""""""""
" set bg=dark
" colo gruvbox
" set notermguicolors
"""""""""""
" colo nord
" set termguicolors
"""""""""""
colo space-vim-dark
hi Comment cterm=italic
" }}}

" {{{ OPTIONS
" status line
set laststatus=2
" encoding/fileformat
set encoding=utf-8
set fileencodings=utf-8,cp1251,ucs-2,koi8-r,cp866
set fileformat=unix
set fileformats=unix,dos,mac
" search
set incsearch
set hlsearch
" tab/space/indent
set tabstop=4       " width for Tab
set shiftwidth=4    " width for shifting with '>>'/'<<'
set softtabstop=4   " width for Tab in inserting or deleting (Backspace)
set smarttab
set expandtab
set autoindent
set nolist
" numbers
set number
set relativenumber
" info/swap/backup
set viminfo="-"
set nobackup
set nowritebackup
set noundofile
" modeline
set modeline
set modelines=5
set noshowmode
set showcmd
" wildmenu
set wildmenu
set wildmode=longest,full
" mouse
set mouse=a
" folding
set foldmethod=indent
set foldlevel=99
" splits
set splitbelow
set splitright
" conceal
set conceallevel=0
set concealcursor=nvic
" tags
set tags=./tags,tags,~/.local/share/tags
" spell
set spell spelllang=
" file search
set path+=**
set wildignore+=*/build/*,*/.git/*,*/node_modules/*
" misc
set completeopt-=preview
set clipboard=unnamedplus
set scrolloff=5
set hidden
set cursorline
set cinoptions=N-s,g0
set matchpairs+=<:>
" }}}

" {{{ MAPPINGS

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
com! Qa :qa
com! -bang Q :q<bang>

" normal mode bindings
nn <silent> <leader>h :noh<Enter>
nn Y y$
nn zq ZQ

" buffer close
nn <silent> <C-q> :close<CR>

" }}}

" {{{ CURSOR
" NOTE: different cursors per mode
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
" }}}

" {{{ SPLIT/RESIZE
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
 " NOTE: it's better to not remap ESC button
nn gr :call ToggleResizeSplitMode()<CR>
" }}}

" {{{ GREPPING
if executable('rg')
  set grepprg=rg\ --vimgrep\ -g\ '!build'\ -F
endif

func! QuickGrep(pattern)
  exe "silent grep! " . a:pattern
  copen
  if line('$') == 1 && getline(1) == ''
    echo "No search results"
    cclose
  else
    let l:nr=winnr()
    exe l:nr . "wincmd J"
  endif
endfunc

command! -nargs=1 QuickGrep call QuickGrep(<f-args>)
nn <leader>g :QuickGrep<space>""<left>
vn <leader>g y:QuickGrep "<C-r>+"<CR>
" }}}

" {{{ FILETREE
let g:netrw_banner = 0
let g:netrw_list_hide = '^\./'
let g:netrw_liststyle = 3
let g:netrw_dirhistmax = 0
nn <silent> <localleader><C-n> :Explore<CR>
nn <silent> <localleader><leader>n :Lexplore<CR>
nn <silent> <leader>_ <Plug>NetrwRefresh
" }}}

" {{{ TABS
nn <silent> th :tabprev<CR>
nn <silent> tl :tabnext<CR>
nn <silent> tn :tabnew<CR>
nn <silent> tc :tabclose<CR>
nn <silent> tH :tabmove -1<CR>
nn <silent> tL :tabmove +1<CR>
" }}}

" {{{ SPELL
nn <silent> <leader>Se :setlocal spell spelllang+=en<CR>
nn <silent> <leader>Sr :setlocal spell spelllang+=ru<CR>
nn <silent> <leader>Sd :setlocal nospell spelllang=<CR>
" }}}

" {{{ SESSIONS
nn <silent> <leader>ms :mksession! <bar> echo "Session saved"<CR>
nn <silent> <leader>ml :source Session.vim<CR>
nn <silent> <leader>md :!rm Session.vim<CR>
" }}}

" {{{ STYLES
" python pep textwidth
au FileType python setlocal textwidth=79 | setlocal colorcolumn=80
" c++ style
au FileType c,cpp,h,hpp setlocal tabstop=4 | setlocal shiftwidth=4 |
      \ setlocal textwidth=120 | setlocal colorcolumn=121
" cmake, js, yaml, proto
au FileType cmake,javascript,typescript,yaml,proto
      \ setlocal tabstop=2 | setlocal shiftwidth=2
" }}}

" {{{ FORMATTERS
" shell
au FileType sh nn <buffer> <C-f> :%!shfmt<CR>
" json
au FileType json nn <buffer> <C-f> :%!jq<CR>
" js,yaml,html,css
au FileType yaml,html,css,javascript,typescript nn <buffer> <C-f> :!prettier --write %<CR>
" }}}

" {{{ MISC
" file executing
nn <leader>e :w <bar> :!compiler %<CR>
nn <leader>E :w <bar> :!compiler % 2<CR>
nn <leader>x :!chmod +x %<CR>
nn <leader>X :!chmod -x %<CR>

" commentstring's
au FileType xdefaults setlocal commentstring=!\ %s
au FileType desktop,sxhkdrc,bib setlocal commentstring=#\ %s

" showing results
au FileType tex,markdown nn <leader>o :!openout %<CR><CR>
au FileType c,cpp nn <leader>o :!./%:r<CR>

" tex
let g:tex_flavor = "latex" " set filetype for tex
au FileType tex nn <leader>c :!texclear %:p:h<CR><CR>
au VimLeave *.tex !texclear %:p:h

" autoremove trailing whitespaces
nn <silent> <leader>w :%s/\s\+$//e <bar> nohl<CR>

" update ctags
com! Ctags execute "!updtags.sh"
nn <silent> <leader>t :Ctags<CR>

" search visually selected text with '//'
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

" replace visually selected text
vnoremap <leader>s y:%s/<C-R>+//g<Left><Left>
" }}}

" {{{ TEMP (Ctrl not working)
nn <silent> <leader><leader>n :Fern . -reveal=%<CR>
nn <silent> <expr> <leader><leader>h !exists('b:SplitResize') ? '<C-w><C-h>' : ':vert res -1<CR>'
nn <silent> <expr> <leader><leader>j !exists('b:SplitResize') ? '<C-w><C-j>' : ':res -1<CR>'
nn <silent> <expr> <leader><leader>k !exists('b:SplitResize') ? '<C-w><C-k>' : ':res +1<CR>'
nn <silent> <expr> <leader><leader>l !exists('b:SplitResize') ? '<C-w><C-l>' : ':vert res +1<CR>'
nn <leader><leader>= <C-w>=
nn <leader><leader>o <C-o>
nn <leader><leader>i <C-i>
nn <leader><leader>t <C-]>
nn <leader><leader>r <C-r>
" }}}
