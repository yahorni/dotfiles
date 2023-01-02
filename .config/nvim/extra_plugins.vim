" extra_plugins.vim

if project#isDirSet()
  " autocomplete
  let completeplug='no' " coc/ycm/etc...
  if (completeplug=='ycm')
    " {{{ ycm
    Plug 'ycm-core/YouCompleteMe'
    nn <localleader>y :YcmRestartServer<CR>
    let g:ycm_global_ycm_extra_conf = getcwd() . "/.nvim/ycm.py"
    let g:ycm_confirm_extra_conf = 0
    nn <silent> <leader>k :YcmCompleter GetDoc<CR>
    " }}}
  elseif (completeplug=='coc')
    " {{{ coc.nvim
    Plug 'Shougo/neoinclude.vim'
    Plug 'jsfaint/coc-neoinclude'
    Plug 'neoclide/coc.nvim'
    " tab completion
    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~ '\s'
    endfunction
    ino <silent><expr> <TAB>
      \  pumvisible() ? "\<C-n>" :
      \  <SID>check_back_space() ? "\<TAB>" :
      \  coc#refresh()
    ino <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    ino <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    ino <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
    " remap keys for gotos
    nm <silent> gd <Plug>(coc-definition)
    nm <silent> gy <Plug>(coc-type-definition)
    nm <silent> gi <Plug>(coc-implementation)
    " refresh
    ino <silent><expr> <C-space> coc#refresh()
    " symbol renaming
    nm <leader>R <Plug>(coc-rename)
    " }}}
  endif
endif

" {{{ DEBUG
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
nn <localleader>k <Plug>VimspectorContinue
" }}}

" {{{ SNIPPETS
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
" }}}

" tree-sitter syntax highlight
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" targets/objects manipulations
Plug 'michaeljsmith/vim-indent-object'
Plug 'wellle/targets.vim'

" indentation
Plug 'Yggdroot/indentLine' " can break conceallevel
let g:indentLine_faster = 1
if !has('nvim')
  let g:indentLine_char = '|'
endif
au FileType tex,markdown,json let g:indentLine_setColors = 0
au FileType tex,markdown,json let g:indentLine_enabled = 0

" language switching
Plug 'lyokha/vim-xkbswitch'
let g:XkbSwitchEnabled = 1
let g:XkbSwitchLib = '/usr/lib/libxkbswitch.so'

" {{{ TEMP (Ctrl not working)
nn <silent> <expr> <A-h> !exists('b:SplitResize') ? '<C-w><C-h>' : ':vert res -1<CR>'
nn <silent> <expr> <leader><leader>j !exists('b:SplitResize') ? '<C-w><C-j>' : ':res -1<CR>'
nn <silent> <expr> <leader><leader>k !exists('b:SplitResize') ? '<C-w><C-k>' : ':res +1<CR>'
nn <silent> <expr> <A-l> !exists('b:SplitResize') ? '<C-w><C-l>' : ':vert res +1<CR>'
nn <leader><leader>o <C-o>
nn <A-i> <C-i>
nn <A-v> <C-v>
nn <A-]> <C-]>
nn <A-r> <C-r>
nn <A-a> <C-a>
nn <A-x> <C-x>
nn <A-w> <C-w>
nm <A-f> <C-f>
nm <A-t> <C-t>
nm <silent> <leader><leader>n :Fern . -reveal=%<CR>
im \\k <C-k>
im \\f <C-x><C-f>
" }}}
