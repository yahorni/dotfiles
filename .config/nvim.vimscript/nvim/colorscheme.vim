" colorscheme.vim

if has('nvim')
  set termguicolors
endif

if has('nvim')
  " colo nightfox
  " colo dayfox
  " colo dawnfox
  " colo duskfox
  " colo nordfox
  " colo terafox
  " colo carbonfox
  " ---
  colo melange
else
  " colo space-vim-dark
  " ---
  set t_Co=256
  set background=dark
  colo PaperColor
endif

" comments
hi Comment cterm=italic
