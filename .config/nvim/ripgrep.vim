" ripgrep.vim

if executable('rg')
  function! SetGrepToRG()
    if exists("g:grepignore")
      exe "set grepprg=rg-vim.sh\\ -d\\ ".join(g:grepignore, ',')
    else
      set grepprg=rg-vim.sh
    endif
  endfunction

  call SetGrepToRG()

  function! RipGrep(pattern, where, type)
    let l:escapedpattern = escape(a:pattern, '%\""')

    if a:type == 'fixed'
      let l:commandprefix = 'silent grep! -F -e "'
    elseif a:type == 'pattern'
      let l:commandprefix = 'silent grep! -e "'
    endif

    if a:where == 'all'
      let l:commandsuffix = '"'
    elseif a:where == 'file'
      let l:commandsuffix = '" ' . expand('%')
    elseif a:where == 'dir'
      let l:commandsuffix = '" ' . expand('%:p:h')
    endif

    exe l:commandprefix . l:escapedpattern . l:commandsuffix

    copen
    if line('$') == 1 && getline(1) == ''
      echo 'No search results'
      cclose
    else
      let l:nr=winnr()
      exe l:nr . 'wincmd J'
    endif
  endfunction

  command! -nargs=1 RGFixed call RipGrep(<f-args>, 'all', 'fixed')
  nn <leader>gg :RGFixed<space>
  vn <leader>gg y:RGFixed <C-r>+<CR>
  nn <leader>g/ :RGFixed<space><C-r>0<CR>
  nn <leader>gs viwy:RGFixed <C-r>+<CR>

  command! -nargs=1 RGPattern call RipGrep(<f-args>, 'all', 'pattern')
  nn <localleader>gg :RGPattern<space>
  vn <localleader>gg y:RGPattern <C-r>+<CR>
  nn <localleader>g/ :RGPattern<space><C-r>0<CR>

  command! -nargs=1 RGFixedFile call RipGrep(<f-args>, 'file', 'fixed')
  nn <leader>gf :RGFixedFile<space>
  vn <leader>gf y:RGFixedFile <C-r>+<CR>

  command! -nargs=1 RGPatternFile call RipGrep(<f-args>, 'file', 'pattern')
  nn <localleader>gf :RGPatternFile<space>
  vn <localleader>gf y:RGPatternFile <C-r>+<CR>

  command! -nargs=1 RGFixedDir call RipGrep(<f-args>, 'dir', 'fixed')
  nn <leader>gd :RGFixedDir<space>
  vn <leader>gd y:RGFixedDir <C-r>+<CR>

  command! -nargs=1 RGPatternDir call RipGrep(<f-args>, 'dir', 'pattern')
  nn <localleader>gd :RGPatternDir<space>
  vn <localleader>gd y:RGPatternDir <C-r>+<CR>
endif
