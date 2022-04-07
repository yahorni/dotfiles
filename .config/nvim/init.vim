" vim: fdm=marker fdl=0
set nocompatible

" set leader key
let mapleader=" "
let maplocalleader=","

" {{{ PLUGINS
call plug#begin()

" treeview
if has('nvim')
  Plug 'antoinemadec/FixCursorHold.nvim'
endif
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-hijack.vim'
nn <silent> <C-n> :Fern . -reveal=%<CR>
nn <silent> <leader>n :Fern . -reveal=% -drawer -toggle<CR>
let g:fern#disable_default_mappings = 1
let g:fern#disable_viewer_hide_cursor = 1

function! FernInit() abort
  nm <buffer><nowait> <CR> <Plug>(fern-action-open-or-expand)
  nm <buffer><nowait> l <Plug>(fern-action-open-or-expand)
  nm <buffer><nowait> h <Plug>(fern-action-collapse)
  nm <buffer><nowait> s <Plug>(fern-action-open:split)
  nm <buffer><nowait> v <Plug>(fern-action-open:vsplit)
  nm <buffer><nowait> r <Plug>(fern-action-reload:cursor)
  nm <buffer><nowait> R <Plug>(fern-action-reload:all)
  nm <buffer><nowait> u <Plug>(fern-action-leave)
  nm <buffer><nowait> d <Plug>(fern-action-enter)
  nm <buffer><nowait> c <Plug>(fern-action-cancel)
  nm <buffer> za <Plug>(fern-action-hidden:toggle)
  nm <buffer> yy <Plug>(fern-action-yank:label)
  nm <buffer> yb <Plug>(fern-action-yank)
endfunction

augroup FernGroup
  autocmd!
  autocmd FileType fern call FernInit()
augroup END

" comments
Plug 'tpope/vim-commentary'
nm <C-_> <plug>CommentaryLine<ESC>j
vm <C-_> <plug>Commentary<ESC>

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
let g:lightline = {
  \  'active': {'left': [['mode', 'paste'], ['readonly', 'relativepath', 'modified']]},
  \  'inactive': {'left': [['relativepath', 'modified']]}
  \}

" snippets
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'honza/vim-snippets'
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets,~/.vim/snippets'
im <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xm <C-k> <Plug>(neosnippet_expand_target)
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
  \  "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" linting
Plug 'w0rp/ale'
let g:ale_fixers = { '*': ['remove_trailing_lines', 'trim_whitespace'] }
let g:ale_linters = {
  \  'cpp': ['cpplint', 'cc', 'clangtidy', 'clang-format'],
  \  'c': ['cc', 'clangtidy', 'clang-format'],
  \  'sh': ['shfmt', 'shellcheck'],
  \  'python': ['flake8', 'pylint'],
  \  'tex': ['chktex'],
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
  \'--linelength=120 --filter=-legal/copyright,-readability/todo,
  \-runtime/references,-build/include_order,-build/include'
let g:ale_cpp_cc_options = '-std=c++17 -Wall -Wextra -pedantic'
" python
let g:ale_python_flake8_options = '--max-line-length=120'
" completion
set omnifunc=ale#completion#OmniFunc
nm <localleader>l <Plug>(ale_lint)
nm <localleader>t <Plug>(ale_toggle)
nm <localleader>f <Plug>(ale_fix)
nm <localleader>d <Plug>(ale_detail)
nm <localleader>] <Plug>(ale_next)
nm <localleader>[ <Plug>(ale_previous)
nm <localleader>} <Plug>(ale_next_error)
nm <localleader>{ <Plug>(ale_previous_error)

" python
Plug 'vim-scripts/indentpython.vim'

" go
Plug 'fatih/vim-go'
au FileType go let g:go_fmt_fail_silently = 1
au FileType go let g:go_fmt_autosave = 0

" fzf
if filereadable('/usr/bin/fzf')
  Plug '/usr/bin/fzf'
else
  Plug 'junegunn/fzf'
endif
Plug 'junegunn/fzf.vim'
nn <silent> <C-b> :Buffers<CR>
nn <silent> <leader>b :FZF<CR>

" c++
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'rhysd/vim-clang-format'
Plug 'derekwyatt/vim-fswitch'
au FileType c,cpp nn <silent> <leader>o :FSHere<CR>

" indentation
Plug 'Yggdroot/indentLine' " can break conceallevel
if !has('nvim')
  let g:indentLine_char = '|'
endif
au FileType tex,markdown,json let g:indentLine_setColors = 0
au FileType tex,markdown,json let g:indentLine_enabled = 0

" theme
Plug 'Rigellute/shades-of-purple.vim'
Plug 'liuchengxu/space-vim-dark'
Plug 'NLKNguyen/papercolor-theme'

" additional plugins
if filereadable(expand('<sfile>:p:h') . '/extra.vim')
  exec "source " . expand('<sfile>:p:h') . '/extra.vim'
endif

call plug#end()

filetype plugin on
" }}}

" {{{ COLORTHEME
" if has('nvim')
"   set termguicolors
" endif
" colo shades_of_purple
" let g:lightline = { 'colorscheme': 'shades_of_purple' }
" ---
colo space-vim-dark
" ---
" set t_Co=256
" set background=dark
" colo PaperColor
" ---
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
set tags=./tags,tags,.nvim/tags,~/.local/share/tags
set notagrelative " prevent '.nvim' prefix for tag
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
set noautoread
set cursorline
set cinoptions=N-s,g0
set matchpairs+=<:>
set sessionoptions-=blank
set noexrc
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

" {{{ GREP
if executable('rg')
  set grepprg=rg-vim.sh

  func! QuickGrep(pattern, type)
    if a:pattern == '""'
      echo "Empty search string given"
      return 1
    endif

    if a:type == 'all'
      exe "silent grep! " . a:pattern
    elseif a:type == 'file'
      exe "silent grep! " . a:pattern . " " . expand('%')
    elseif a:type == 'dir'
      exe "silent grep! " . a:pattern . " " . expand('%:p:h')
    endif

    copen
    if line('$') == 1 && getline(1) == ''
      echo "No search results"
      cclose
    else
      let l:nr=winnr()
      exe l:nr . "wincmd J"
    endif
  endfunc

  command! -nargs=1 QuickGrep call QuickGrep(<f-args>, "all")
  nn <leader>gg :QuickGrep<space>""<left>
  vn <leader>gg y:QuickGrep "<C-r>+"<CR>
  nn <leader>g/ :QuickGrep<space>"<C-r>0"<CR>

  command! -nargs=1 QuickGrepFile call QuickGrep(<f-args>, "file")
  nn <leader>gf :QuickGrepFile<space>""<left>
  vn <leader>gf y:QuickGrepFile "<C-r>+"<CR>

  command! -nargs=1 QuickGrepDir call QuickGrep(<f-args>, "dir")
  nn <leader>gd :QuickGrepDir<space>""<left>
  vn <leader>gd y:QuickGrepDir "<C-r>+"<CR>
endif
" }}}

" {{{ FILETREE
let g:netrw_banner = 0
let g:netrw_list_hide = '^\./'
let g:netrw_liststyle = 3
let g:netrw_dirhistmax = 0
nn <silent> <localleader>N :Explore<CR>
nn <silent> <localleader>n :Lexplore<CR>
nn <silent> <localleader>_ <Plug>NetrwRefresh
" }}}

" {{{ TABS
nn <silent> th :tabprev<CR>
nn <silent> tl :tabnext<CR>
nn <silent> tn :tabnew %<CR>
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
nn <silent> <leader>s :mksession! .nvim/session.vim <bar> echo "Session saved"<CR>
nn <silent> <leader>l :source .nvim/session.vim<CR>
nn <silent> <leader>r :!rm .nvim/session.vim<CR><CR>:echo "Session removed"<CR>
" }}}

" {{{ STYLES
" textwidth
au FileType c,cpp,sh,python setlocal textwidth=120 | setlocal colorcolumn=120
" tab style (4 spaces)
au FileType c,cpp,sh setlocal tabstop=4 | setlocal shiftwidth=4 | setlocal softtabstop=4
" tab style (2 spaces)
au FileType vim,cmake,javascript,typescript,yaml,proto
  \  setlocal tabstop=2 | setlocal shiftwidth=2 | setlocal softtabstop=2
" }}}

" {{{ FORMATTERS
" c/c++
au FileType c,cpp,javascript,typescript,proto nn <buffer> <C-f> :ClangFormat<CR>
au FileType c,cpp,javascript,typescript,proto vn <buffer> <C-f> :ClangFormat<CR>
" shell
au FileType sh nn <buffer> <C-f> :%!shfmt<CR>
au FileType sh vn <buffer> <C-f> :%!shfmt<CR>
" json
au FileType json nn <buffer> <C-f> :%!jq<CR>
au FileType json vn <buffer> <C-f> :%!jq<CR>
" yaml,html,css
au FileType yaml,html,css nn <buffer> <C-f> :!prettier --write %<CR>
" cmake
au FileType cmake nn <buffer> <C-f> :!cmake-format --line-width 120 -i % <CR><CR>:e<CR>
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
au FileType c,cpp setlocal commentstring=//\ %s

" showing results
au FileType tex,markdown nn <leader>o :!openout %<CR><CR>

" tex
let g:tex_flavor = "latex" " set filetype for tex
au FileType tex nn <leader>c :!texclear %:p:h<CR><CR>
au VimLeave *.tex !texclear %:p:h

" autoremove trailing whitespaces
nn <silent> <leader>w :%s/\s\+$//e <bar> nohl<CR>

" update ctags
com! Ctags execute "!mkdir -p .nvim ; updtags.sh .nvim/tags ."
nn <silent> <leader>t :Ctags<CR>

" search visually selected text with '//'
vn // y/\V<C-R>=escape(@",'/\')<CR><CR>

" replace visually selected text
vn <leader>s y:%s/<C-R>+//g<Left><Left>

" use K for c++ man pages
au FileType c,cpp setlocal keywordprg=cppman

" git blame
nn gb :execute "! git blame -L " . max([eval(line(".")-5), 1]) . ",+10 %"<CR>

" remove swaps
nn <leader>D :!rm ~/.local/share/nvim/swap/*.swp<CR>

" prevent 'file changed' warnings
autocmd FileChangedShell * :

" close all buffers except opened one
command! BufOnly silent! execute "%bd|e#|bd#"

" create '.nvim' directory
nn <silent> <leader>d :!mkdir .nvim ; touch .nvim/Makefile<CR>
" }}}

" {{{ LOCAL VIMRC
" NOTE: should be in the end to override previous options
if filereadable(".nvim/init.vim")
  exec "source " . ".nvim/init.vim"
endif
" }}}

" {{{ NOTES
" # reformat file for linux/utf-8
" set fileformat=unix fileencoding=utf-8
" set ff=unix fenc=utf-8
"
" # open nvim without config
" $ nvim --clean                      # since v8
" $ nvim -u DEFAULTS -U NONE -i NONE  # before v8
"
" # vim-plug installation
" 1. vim
" $ curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" 2. neovim
" $ sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
"       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
" 3. after updating plugins in neovim - create link for vim
" $ ln -s ~/.local/share/nvim/plugged ~/.vim/plugged
"
" # YCM installation
" > don't forget to use corresponding gcc version
" $ cd .vim/plugged/YouCompleteMe/
" $ python3 install.py --clang-completer
"
" # fzf installation (locally, no package manager)
" git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
" ~/.fzf/install
" }}}
