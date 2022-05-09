" vim: fdm=marker fdl=0
set nocompatible

" set leader key
let mapleader=' '
let maplocalleader=','

" ensure IDE directory is set
if empty($IDE_DIR)
  let $IDE_DIR='.ide'
endif

" check whether first buffer in project directory
function! IsProject() abort
  return isdirectory($IDE_DIR) && (empty(expand('%')) || stridx(expand('%:p'), getcwd()) != -1)
endfunction

" {{{ PLUGINS
call plug#begin()

" treeview
if has('nvim')
  Plug 'antoinemadec/FixCursorHold.nvim'
endif
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-hijack.vim'
nn <silent> <C-n> :Fern . -reveal=%<CR>
nn <silent> <leader>n :Fern %:p:h -reveal=%<CR>
nn <silent> <leader>T :Fern . -reveal=% -drawer -toggle<CR>
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
  \  '\<Plug>(neosnippet_expand_or_jump)' : '\<TAB>'

" linting
Plug 'w0rp/ale'
" NOTE: do not use 'clangd' linter as it's too heavy
let g:ale_linters = {
  \  'cpp': ['cpplint', 'cc', 'clangtidy'],
  \  'c': ['cpplint', 'cc', 'clangtidy'],
  \  'cmake': ['cmake_lint'],
  \  'sh': ['shellcheck'],
  \  'python': ['flake8', 'pylint'],
  \  'tex': ['chktex'],
  \}
let g:ale_fixers = {
  \  '*': ['remove_trailing_lines', 'trim_whitespace'],
  \  'cpp': ['clangtidy', 'clang-format'],
  \  'c': ['clangtidy', 'clang-format'],
  \  'cmake': ['cmakeformat'],
  \  'sh': ['shfmt'],
  \  'python': ['autoimport', 'isort', 'autoflake', 'autopep8']
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
let g:ale_c_cpplint_options =
  \'--linelength=120 --filter=-legal/copyright,-legal/license,
  \-whitespace/todo,-readability/todo,-runtime/references,
  \-build/include_order,-build/include'
let g:ale_cpp_cpplint_options = g:ale_c_cpplint_options
let g:ale_cpp_cc_options = '-std=c++17 -Wall -Wextra -pedantic'
" python
let g:ale_python_flake8_options = '--max-line-length=120'
let g:ale_python_autopep8_options = '--max-line-length=120'
" cmake
let g:ale_cmake_cmake_lint_executable = 'cmake-lint'
let g:ale_cmake_cmake_lint_options = '--line-width=120'
let g:ale_cmake_cmakeformat_executable = 'cmake-format'
let g:ale_cmake_cmakeformat_options = '--line-width=120'
" completion
set omnifunc=ale#completion#OmniFunc
nm <localleader>l <Plug>(ale_lint)
nm <localleader>e <Plug>(ale_enable)
nm <localleader>d <Plug>(ale_disable)
nm <localleader>f <Plug>(ale_fix)
nm <localleader>i <Plug>(ale_detail)
nm <localleader>] <Plug>(ale_next)
nm <localleader>[ <Plug>(ale_previous)
nm <localleader>} <Plug>(ale_next_error)
nm <localleader>{ <Plug>(ale_previous_error)

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

" theme
Plug 'Rigellute/shades-of-purple.vim'
Plug 'liuchengxu/space-vim-dark'
Plug 'NLKNguyen/papercolor-theme'

" git
Plug 'airblade/vim-gitgutter'

" auto tag management
Plug 'ludovicchabant/vim-gutentags'
if IsProject()
  let g:gutentags_ctags_executable = 'guten.sh'
  let g:gutentags_ctags_tagfile = $IDE_DIR . '/tags'
  nn <localleader>t :GutentagsUpdate!<CR>
  " NOTE: to debug gutentags uncomment line below
  " let g:gutentags_trace = 1
else
  let g:gutentags_dont_load = 1
endif

" markdown
Plug 'plasticboy/vim-markdown'

" aligning text
" NOTE: http://vimcasts.org/episodes/aligning-text-with-tabular-vim/
Plug 'godlygeek/tabular'

" highlight colors
Plug 'ap/vim-css-color'

" python
Plug 'vim-scripts/indentpython.vim'

" additional plugins
if filereadable(expand('<sfile>:p:h') . '/extra.vim')
  exec 'source ' . expand('<sfile>:p:h') . '/extra.vim'
endif

call plug#end()

filetype plugin indent on
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
set tags=./tags,tags,$IDE_DIR/tags,~/.local/share/tags
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
set sessionoptions-=blank
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

" newline without insert mode
nn <localleader>o o<ESC>
nn <localleader>O O<ESC>

" }}}

" {{{ CURSOR
" NOTE: different cursors per mode
if (&term!='linux')
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

" {{{ GREP
if executable('rg')
  set grepprg=rg-vim.sh

  function! QuickGrep(pattern, type)
    let l:escapedpattern = escape(a:pattern, '%\""')

    if a:type == 'all'
      exe 'silent grep! "' . l:escapedpattern . '"'
    elseif a:type == 'file'
      exe 'silent grep! "' . l:escapedpattern . '" ' . expand('%')
    elseif a:type == 'dir'
      exe 'silent grep! "' . l:escapedpattern . '" ' . expand('%:p:h')
    endif

    copen
    if line('$') == 1 && getline(1) == ''
      echo 'No search results'
      cclose
    else
      let l:nr=winnr()
      exe l:nr . 'wincmd J'
    endif
  endfunction

  command! -nargs=1 QuickGrep call QuickGrep(<f-args>, 'all')
  nn <leader>gg :QuickGrep<space>
  vn <leader>gg y:QuickGrep <C-r>+<CR>
  nn <leader>g/ :QuickGrep<space><C-r>0<CR>

  command! -nargs=1 QuickGrepFile call QuickGrep(<f-args>, 'file')
  nn <leader>gf :QuickGrepFile<space>
  vn <leader>gf y:QuickGrepFile <C-r>+<CR>

  command! -nargs=1 QuickGrepDir call QuickGrep(<f-args>, 'dir')
  nn <leader>gd :QuickGrepDir<space>
  vn <leader>gd y:QuickGrepDir <C-r>+<CR>
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
nn <silent> <leader>s :mksession! $IDE_DIR/session.vim <bar> echo 'Session saved'<CR>
nn <silent> <leader>l :source $IDE_DIR/session.vim<CR>
nn <silent> <leader>r :!rm $IDE_DIR/session.vim<CR><CR>:echo 'Session removed'<CR>
" }}}

" {{{ STYLES
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
" xml
au FileType xml nn <buffer> <C-f> :%! xmllint --format --recover - 2>/dev/null<CR>
au FileType xml vn <buffer> <C-f> :! xmllint --format --recover - 2>/dev/null<CR>
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
let g:tex_flavor = 'latex' " set filetype for tex
au FileType tex nn <leader>c :!texclear %:p:h<CR><CR>
au VimLeave *.tex !texclear %:p:h

" autoremove trailing whitespaces
nn <silent> <leader>w :%s/\s\+$//e <bar> nohl<CR>

" update ctags manually
nn <silent> <leader>t :!updtags.sh $IDE_DIR/tags .<CR>

" search visually selected text with '//'
vn // y/\V<C-R>=escape(@",'/\')<CR><CR>

" replace visually selected text
vn <leader>s y:%s/<C-R>+//g<Left><Left>

" use K for c++ man pages
au FileType c,cpp setlocal keywordprg=cppman

" git blame
nn gb :execute '! git blame -L ' . max([eval(line('.')-5), 1]) . ',+10 %'<CR>

" remove swaps
nn <leader>D :!rm ~/.local/share/nvim/swap/*<CR>

" prevent 'file changed' warnings
autocmd FileChangedShell * :

" close all buffers except opened one
command! BufOnly silent! execute '%bd|e#|bd#'
" }}}

" {{{ LOCAL VIMRC
" NOTE: should be in the end to override previous options
if filereadable($IDE_DIR . '/init.vim')
  exec 'source '. $IDE_DIR . '/init.vim'
endif
" }}}

" {{{ NOTES
" # reformat file for linux/utf-8
" set fileformat=unix fileencoding=utf-8
" set ff=unix fenc=utf-8
"
" # set tab width to other value (for example: 2)
" set ts=2 | set sw=2 | set sts=2
" au FileType sh setl ts=2 | setl sw=2 | setl sts=2
" # disable expanding tabs to spaces
" set noet
"
" # modeline example
" # vim:ft=vim:ts=4:sw=4:sts=4:fdm=marker:fdl=0:cms=#\ %s
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
" 4. [optional] link vim setup for root
" $ sudo mkdir -pv "/root/.local/share/nvim/{plugged,autoload}" "/root/.vim/"
" $ sudo ln -s ~/.local/share/nvim/site/autoload /root/.local/share/nvim/site/autoload
" $ sudo ln -s ~/.local/share/nvim/site/autoload /root/.vim/autoload
" $ sudo ln -s ~/.local/share/nvim/plugged /root/.local/share/nvim/plugged
" $ sudo ln -s ~/.local/share/nvim/plugged /root/.vim/plugged
"
" # YCM installation
" > don't forget to use corresponding gcc version
" $ cd .vim/plugged/YouCompleteMe/
" $ python3 install.py --clang-completer
" > or this (in case previous option doesn't work)
" $ python3 install.py --clangd-completer
"
" # coc.nvim compilation
" $ cd ~/.local/share/nvim/plugged/coc.nvim/
" $ yarn install
" $ yarn build
"
" # pycscope installation (locally)
" $ pip install git+https://github.com/portante/pycscope
" }}}
