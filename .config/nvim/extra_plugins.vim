" extra_plugins.vim

if project#isDirSet()
  " autocomplete
  let g:complete_plugin = 'ycm'  " coc/ycm/lsp
  if (g:complete_plugin=='ycm')
    " {{{ ycm
    Plug 'ycm-core/YouCompleteMe'
    nn <localleader>y :YcmRestartServer<CR>
    let g:ycm_global_ycm_extra_conf = getcwd().'/'.$IDE_DIR.'/ycm.py'
    let g:ycm_confirm_extra_conf = 0
    nn <silent> <leader>k :YcmCompleter GetDoc<CR>
    nn <silent> <leader>] :YcmCompleter GoToDefinition<CR>
    nn <silent> <leader>[ :YcmCompleter GoToReferences<CR>
    nn <silent> <leader>O :YcmCompleter GoToAlternateFile<CR>
    " }}}
  elseif (g:complete_plugin=='coc')
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
      \  pumvisible() ? '\<C-n>' :
      \  <SID>check_back_space() ? '\<TAB>' :
      \  coc#refresh()
    ino <expr> <Tab> pumvisible() ? '\<C-n>' : '\<Tab>'
    ino <expr> <S-Tab> pumvisible() ? '\<C-p>' : '\<S-Tab>'
    ino <expr> <cr> pumvisible() ? '\<C-y>' : '\<C-g>u\<CR>'
    " remap keys for gotos
    nm <silent> gd <Plug>(coc-definition)
    nm <silent> gy <Plug>(coc-type-definition)
    nm <silent> gi <Plug>(coc-implementation)
    " refresh
    ino <silent><expr> <C-space> coc#refresh()
    " symbol renaming
    nm <leader>R <Plug>(coc-rename)
    " }}}
  elseif (g:complete_plugin=='lsp')
    Plug 'williamboman/mason.nvim'
    Plug 'williamboman/mason-lspconfig.nvim'
    Plug 'neovim/nvim-lspconfig'
  endif
endif

" tree-sitter syntax highlight
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" targets/objects manipulations
Plug 'michaeljsmith/vim-indent-object'
Plug 'wellle/targets.vim'

" telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
nnoremap <leader>ff <cmd>Telescope find_files<CR>
nnoremap <leader>fg <cmd>Telescope live_grep<CR>
nnoremap <leader>fb <cmd>Telescope buffers<CR>
nnoremap <leader>fh <cmd>Telescope help_tags<CR>

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
