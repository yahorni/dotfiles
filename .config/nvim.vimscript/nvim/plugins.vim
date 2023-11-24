" plugins.vim
" contains plugins and colortheme setting

call plug#begin()

if has('nvim')
" {{{ fern treeview
  Plug 'antoinemadec/FixCursorHold.nvim'
  Plug 'lambdalisue/fern.vim'
  Plug 'lambdalisue/fern-hijack.vim'
  nn <silent> <C-n> :Fern . -reveal=%<CR>
  nn <silent> <leader>n :Fern %:p:h -reveal=%:p<CR>
  nn <silent> <leader>N :Fern . -reveal=% -drawer -toggle<CR>
  let g:fern#default_hidden = 1
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
    nm <buffer><nowait> D <Plug>(fern-action-remove)
    nm <buffer> za <Plug>(fern-action-hidden:toggle)
    nm <buffer> yy <Plug>(fern-action-yank:label)
    nm <buffer> yb <Plug>(fern-action-yank)
  endfunction

  augroup FernGroup
    autocmd!
    autocmd FileType fern call FernInit()
  augroup END

  if g:has_project_config && isdirectory(".git")
    Plug 'lambdalisue/fern-git-status.vim'
    let g:fern_git_status#disable_ignored = 1
    let g:fern_git_status#disable_submodules = 1
  endif
" }}}

" {{{ ale linter/fixer
  Plug 'w0rp/ale'
  " NOTE: do not use 'clangd' linter as it's too heavy
  let g:ale_linters = {
    \  'cpp': ['cpplint', 'cc', 'clangtidy', 'cppcheck', 'flawfinder'],
    \  'c': ['cpplint', 'cc', 'clangtidy', 'cppcheck', 'flawfinder'],
    \  'cmake': ['cmake_lint'],
    \  'sh': ['shellcheck'],
    \  'python': ['flake8', 'pylint'],
    \  'tex': ['chktex'],
    \  'json': ['jq'],
    \  'xml': ['xmllint'],
    \}
  let g:ale_fixers = {
    \  '*': ['remove_trailing_lines', 'trim_whitespace'],
    \  'cpp': ['clangtidy', 'clang-format'],
    \  'c': ['clangtidy', 'clang-format'],
    \  'cmake': ['cmakeformat'],
    \  'sh': ['shfmt'],
    \  'python': ['autoimport', 'isort', 'autoflake', 'autopep8'],
    \  'json': ['jq', 'prettier', 'clang-format'],
    \  'html': ['prettier'],
    \  'xml': ['xmllint'],
    \}
  let g:ale_linters_explicit = 1
  let g:ale_set_highlights = 1
  let g:ale_lint_on_text_changed = 'never'
  let g:ale_lint_on_enter = 0
  let b:ale_list_window_size = 5
  if has('nvim')
    let g:ale_use_neovim_diagnostics_api = 1
  endif
  " tex options
  " 13 - intersentence spacing
  " 26 - spaces before punctuation
  " 44 - hline in tables
  let g:ale_tex_chktex_options = '-n13 -n26 -n44'
  " c/c++ options
  " NOTE: cpp headers issue
  let g:ale_c_parse_compile_commands = 1
  let g:ale_c_cpplint_options = '--linelength=120'
  let g:ale_cpp_cpplint_options = g:ale_c_cpplint_options
  let g:ale_cpp_cc_options = '-std=c++17 -Wall -Wextra -pedantic'
  " python
  let g:ale_python_flake8_options = '--max-line-length=120'
  let g:ale_python_autopep8_options = '--max-line-length=120'
  let g:ale_python_isort_options = '--line-length=120'
  " cmake
  let g:ale_cmake_cmake_lint_executable = 'cmake-lint'
  let g:ale_cmake_cmake_lint_options = '--line-width=120'
  let g:ale_cmake_cmakeformat_executable = 'cmake-format'
  let g:ale_cmake_cmakeformat_options = '--line-width=120'
  " shell
  let g:ale_sh_shfmt_options = '-i 4'
  " completion (disabling to not interfere with YCM)
  let g:ale_disable_lsp = 1
  " let g:ale_completion_enabled = 1
  " set omnifunc=ale#completion#OmniFunc
  " hotkeys
  nm <localleader>a <Plug>(ale_lint)
  nm <localleader>e <Plug>(ale_enable)
  nm <localleader>d <Plug>(ale_disable)
  nm <localleader>f <Plug>(ale_fix)
  nm <localleader>i <Plug>(ale_detail)
  nm <localleader>] <Plug>(ale_next)
  nm <localleader>[ <Plug>(ale_previous)
  nm <localleader>} <Plug>(ale_next_error)
  nm <localleader>{ <Plug>(ale_previous_error)
  nm <silent> <localleader>I :ALEInfo<CR>
  nm <silent> <localleader>p :ALEPopulateLocList<CR>
" }}}

" {{{ vim-go
  Plug 'fatih/vim-go'
  au FileType go let g:go_fmt_fail_silently = 1
  au FileType go let g:go_fmt_autosave = 0
" }}}

" {{{ git
  Plug 'rhysd/conflict-marker.vim'
  " ]x and [x to jump; ct/co/cb - take theirs/ours/both changes
  Plug 'airblade/vim-gitgutter'
  nn <leader>gt :GitGutterToggle<CR>
  nn <leader>p <Plug>(GitGutterPreviewHunk)
  nn <leader>+ <Plug>(GitGutterStageHunk)
  nn <leader>- <Plug>(GitGutterUndoHunk)
  if executable('rg')
    let g:gitgutter_grep = 'rg'
  endif
" }}}

" {{{ debug
Plug 'puremourning/vimspector'
let g:vimspector_install_gadgets = ['debugpy', 'vscode-cpptools']

nn <leader>d :call vimspector#Launch()<CR>
nn <leader>q :call vimspector#Reset()<CR>
nn <localleader>r :call vimspector#Restart()<CR>
nn <localleader>b <Plug>VimspectorToggleBreakpoint
nn <localleader>B <Plug>VimspectorBreakpoints
nn <localleader>s <Plug>VimspectorStop
nn <localleader>l <Plug>VimspectorStepInto
nn <localleader>h <Plug>VimspectorStepOut
nn <localleader>j <Plug>VimspectorStepOver
nn <localleader>c <Plug>VimspectorContinue
" }}}
endif

" comments
Plug 'tpope/vim-commentary'
nm <C-_> <plug>CommentaryLine<ESC>j
vm <C-_> <plug>Commentary<ESC>

" tagbar
Plug 'preservim/tagbar'
nn <silent> <leader>T :TagbarToggle<CR>

" improved quoting/parenthesizing
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat' " dot command for vim-surround

" highlight for substituion
Plug 'markonm/traces.vim'

" rename file
Plug 'vim-scripts/Rename2'

" status line
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
let g:lightline = {
  \  'active': {
  \    'left': [['mode', 'paste'], ['readonly', 'relativepath', 'modified'], ['gitbranch']],
  \    'right': [['lineinfo'], ['percent'], ['fileformat', 'fileencoding', 'filetype', 'charvaluehex']]
  \  },
  \  'inactive': {
  \    'left': [['relativepath', 'modified']],
  \    'right': [['lineinfo'], ['percent'], ['filetype']]
  \  },
  \  'component': {'charvaluehex': '0x%B'},
  \  'component_function': {'gitbranch': 'gitbranch#name'}
  \}

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
Plug 'nvim-lua/plenary.nvim' " required dependency
Plug 'jakemason/ouroboros'
au FileType c,cpp nn <silent> <leader>o :Ouroboros<CR>

" auto tag management
Plug 'ludovicchabant/vim-gutentags'
if g:has_project_config
  let g:gutentags_ctags_executable = 'guten.sh'
  let g:gutentags_ctags_tagfile = $IDE_DIR.'/tags'
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
" NOTE: align by '=': Tabularize /=
Plug 'godlygeek/tabular'

" highlight colors
Plug 'ap/vim-css-color'

" log files
Plug 'mtdl9/vim-log-highlighting'

" theme
Plug 'liuchengxu/space-vim-dark'
Plug 'NLKNguyen/papercolor-theme'
if has('nvim')
  Plug 'savq/melange-nvim'
  Plug 'EdenEast/nightfox.nvim'
endif

" extra plugins
call TryReadScriptFile('extra_plugins.vim')

" project-specific plugins
if g:has_project_config
  call project#tryReadProjectVimFile('plugins.vim')
endif

call plug#end()

filetype plugin indent on
