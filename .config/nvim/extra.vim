" in vim-plug

let completeplug='ycm' " coc/ycm/etc...

" autocomplete
if (completeplug=='coc')
  Plug 'Shougo/neoinclude.vim'
  Plug 'jsfaint/coc-neoinclude'
  Plug 'neoclide/coc.nvim'
  " extensions
  let g:coc_global_extensions = ['coc-cmake', 'coc-json']
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

elseif (completeplug=='ycm')
  Plug 'ycm-core/YouCompleteMe'
  let g:ycm_global_ycm_extra_conf = getcwd() . "/.nvim/ycm.py"
  let g:ycm_confirm_extra_conf = 0

endif

" language switching
Plug 'lyokha/vim-xkbswitch'
let g:XkbSwitchEnabled = 1
let g:XkbSwitchLib = '/usr/lib/libxkbswitch.so'

" highlight colors
Plug 'ap/vim-css-color'

" syntax files
Plug 'baskerville/vim-sxhkdrc'      " sxhkd
Plug 'tomlion/vim-solidity'         " solidity

" markdown
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

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
nm <silent> <leader><leader>n :Fern . -reveal=%<CR>
im \\k <C-k>
im \\f <C-x><C-f>
" }}}
