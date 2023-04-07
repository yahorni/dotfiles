" init.vim

set nocompatible

" set leader key
let mapleader=' '
let maplocalleader=','

" {{{ SCRIPTS MANAGEMENT
let s:scripts_path = expand('<sfile>:p:h')
function! TryReadScriptFile(filename) abort
  let l:script_path = s:scripts_path.'/'.a:filename
  if filereadable(l:script_path)
    exec 'source '.l:script_path
    return 1
  else
    return 0
  endif
endfunction

" set project directory
let g:has_project_config = TryReadScriptFile('project.vim')
if g:has_project_config
  call project#ensureDirSet()
endif
" }}}

" {{{ FILETREE
let g:netrw_banner = 0
let g:netrw_list_hide = '^\./'
let g:netrw_liststyle = 3
let g:netrw_dirhistmax = 0
nn <silent> <C-n> :Explore<CR>
nn <silent> <leader>n :Explore %:p:h<CR>
nn <silent> <leader>N :Lexplore<CR>
au FileType netrw nn <silent><buffer> r <Plug>NetrwRefresh
" }}}

call TryReadScriptFile('plugins.vim')
call TryReadScriptFile('colorscheme.vim')

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
set tabstop=4         " width for Tab
set shiftwidth=4      " width for shifting with '>>'/'<<'
set softtabstop=4     " width for Tab in inserting or deleting (Backspace)
set smarttab
set expandtab
set autoindent
" nonprintable characters
set list
set listchars=tab:>\ ,trail:·
" line numbers
set number
set relativenumber    " can cause slowdown
" info/swap/backup
set viminfo="-"       " can't use single quotes here
set nobackup
set nowritebackup
set noundofile
" modeline
set modeline
set modelines=5
" messages in last line
set noshowmode
set noshowcmd         " can cause slowdown
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
set notagrelative     " disable directory prefix for tag file
" spell
set spell spelllang=
" file search
set path+=**
set wildignore+=*/build/*,*/.git/*,*/node_modules/*
" enable system clipboard
set clipboard=unnamedplus
" minimal lines before/after cursor
set scrolloff=5
" do not autoreload changed file
set noautoread
" highlight current line
set cursorline        " can cause slowdown
" do not indent: N-s - namespaces, g0 - public/private/protected
set cinoptions=N-s,g0
" enable <> pair
set matchpairs+=<:>
" do not save quickfix to session file
set sessionoptions-=blank,folds
" ignore local .vimrc
set noexrc
" shorten vim messages
set shortmess=atT
" text width
set textwidth=120
set colorcolumn=120
" window title
set title
" misc
set completeopt-=preview
set hidden
" }}}

" {{{ MAPPINGS

" change <paste> command behaviour
xn p "_dp
xn P "_dP

" disable Ex mode
nn Q <nop>

" annoying keys
com! W :w
com! Q :q
com! Wq :wq
com! WQ :wq
com! Qa :qa
com! QA :qa
com! -bang Q :q<bang>
com! -bang Wq :wq<bang>
com! -bang WQ :wq<bang>
com! -bang Qa :qa<bang>
com! -bang QA :qa<bang>

" normal mode bindings
nn <silent> <leader>h :noh<Enter>
nn Y y$
nn zq ZQ

" buffer close
nn <silent> <C-q> :close<CR>

" update file and search
nn <silent> <A-n> :e<CR>n
nn <silent> <A-N> :e<CR>N
" }}}

" {{{ CURSOR
" NOTE: different cursors per mode
if (&term!='linux' && has('nvim'))
  if exists('$TMUX')
    let &t_SI = '\ePtmux;\e\e[6 q\e\\'
    let &t_SR = '\ePtmux;\e\e[4 q\e\\'
    let &t_EI = '\ePtmux;\e\e[2 q\e\\'
  else
    let &t_SI = '\e[6 q'
    let &t_SR = '\e[4 q'
    let &t_EI = '\e[2 q'
  endif
endif
" }}}

" {{{ SPLIT/RESIZE
function! ToggleResizeSplitMode()
  if !exists('b:SplitResize')
    let b:SplitResize=1
    echo 'Resizing enabled'
  else
    unlet b:SplitResize
    echo 'Resizing disabled'
  endif
endfunction

nn <silent> <expr> <C-h> !exists('b:SplitResize') ? '<C-w><C-h>' : ':vert res -1<CR>'
nn <silent> <expr> <C-j> !exists('b:SplitResize') ? '<C-w><C-j>' : ':res -1<CR>'
nn <silent> <expr> <C-k> !exists('b:SplitResize') ? '<C-w><C-k>' : ':res +1<CR>'
nn <silent> <expr> <C-l> !exists('b:SplitResize') ? '<C-w><C-l>' : ':vert res +1<CR>'
 " NOTE: it's better to not remap ESC button
nn gr :call ToggleResizeSplitMode()<CR>
" }}}

" {{{ TABS
nn <silent> th :tabprev<CR>
nn <silent> tl :tabnext<CR>
nn <silent> tn :tabnew %<CR>
nn <silent> tc :tabclose<CR>
nn <silent> tH :tabmove -1<CR>
nn <silent> tL :tabmove +1<CR>

if has('nvim')
  nn <silent> <S-Tab> :tabprev<CR>
  nn <silent> <Tab> :tabnext<CR>
endif
" }}}

" {{{ SESSION
let g:session_file = 'session.vim'
nn <silent> <leader>s :execute 'mksession! '.g:session_file <bar> echo 'Session saved to '.g:session_file<CR>
nn <silent> <leader>l :execute 'source '.g:session_file<CR>
nn <silent> <leader>r :execute '!rm '.g:session_file<CR><CR>:echo 'Session removed'<CR>
" }}}

" {{{ SPELL
nn <silent> <leader>Se :setlocal spell spelllang+=en<CR>
nn <silent> <leader>Sr :setlocal spell spelllang+=ru<CR>
nn <silent> <leader>Sd :setlocal nospell spelllang=<CR>
" }}}

" {{{ STYLES
" tab style (2 spaces)
au FileType vim,cmake,javascript,typescript,yaml,proto
  \  setlocal tabstop=2 | setlocal shiftwidth=2 | setlocal softtabstop=2
au FileType markdown,text setlocal textwidth=0
au FileType vim setlocal foldmethod=marker foldlevel=0
au FileType gitconfig,make setlocal noexpandtab
" }}}

" {{{ FORMATTERS
nn <C-f> :echo 'No specific formatter set'<CR>gg=G
" clang-format | c/c++, js/ts, proto
if executable('clang-format')
  au FileType c,cpp,javascript,typescript,proto nn <buffer> <C-f> :!clang-format -i %<CR><CR>:e<CR>
  au FileType c,cpp,javascript,typescript,proto vn <buffer> <C-f> :%!clang-format --assume-filename=%<CR>
endif
" shfmt | shell
if executable('shfmt')
  au FileType sh nn <buffer> <C-f> :%!shfmt -i 4<CR>
  au FileType sh vn <buffer> <C-f> :%!shfmt -i 4<CR>
endif
" jq | json
if executable('jq')
  au FileType json nn <buffer> <C-f> :%!jq<CR>
  au FileType json vn <buffer> <C-f> :%!jq<CR>
endif
" prettier | yaml, html, css
if executable('prettier')
  au FileType yaml,html,css nn <buffer> <C-f> :!prettier --write %<CR>
endif
" xmllint | xml
if executable('xmllint')
  au FileType xml nn <buffer> <C-f> :%! xmllint --format --recover - 2>/dev/null<CR>
  au FileType xml vn <buffer> <C-f> :! xmllint --format --recover - 2>/dev/null<CR>
endif
" }}}

" {{{ MISC
" file executing
nn <leader>e :w <bar> :!compiler "%"<CR>
nn <leader>E :w <bar> :!compiler run "%"<CR>
nn <localleader>E :w <bar> :!compiler other "%"<CR>
nn <leader>x :!chmod +x %<CR>
nn <leader>X :!chmod -x %<CR>

" commentstrings
au FileType xdefaults setlocal commentstring=!\ %s
au FileType desktop,sxhkdrc,bib setlocal commentstring=#\ %s
au FileType c,cpp setlocal commentstring=//\ %s

" tex
let g:tex_flavor = 'latex' " set filetype for tex
au FileType tex nn <leader>c :!texclear %:p:h<CR><CR>
au VimLeave *.tex !texclear %:p:h

" remove trailing whitespaces
nn <silent> <leader>w :%s/\s\+$//e <bar> nohl<CR>
vn <silent> <leader>w y:'<,'>s/\s\+$//e <bar> nohl<CR>

" remove empty lines
nn <silent> <leader>W :g/^$/d<CR>

" search visually selected text with '//'
vn // y/\V<C-R>=escape(@",'/\')<CR><CR>

" replace visually selected text
vn <leader>s y:%s/<C-R>+//g<Left><Left>

" use K for c++ man pages
if executable('cppman')
  au FileType c,cpp setlocal keywordprg=cppman
endif

" git blame
nn gb :execute '!git blame -L ' . max([eval(line('.')-5), 1]) . ',+10 %'<CR>

" remove swaps
nn <leader>R :!rm -f ~/.local/share/nvim/swap/*<CR>

" prevent 'file changed' warnings
autocmd FileChangedShell * :

" close all buffers except opened one
command! BufOnly silent! execute '%bd|e#|bd#'

" search for exact word
nn <silent> <leader>/ /\<\><Left><Left>

" update ctags manually
nn <silent> <leader>t :!updtags.sh tags .<CR>
" }}}

call TryReadScriptFile('ripgrep.vim')

call TryReadScriptFile('extra_options.vim')

if g:has_project_config
  call project#setupAdditionalFeatures()
  call project#tryReadProjectVimFile('options.vim')
endif
