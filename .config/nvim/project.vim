" project.vim

function! project#ensureDirSet() abort
  if empty($IDE_DIR)
    let $IDE_DIR='.ide'
  endif
endfunction

function! project#isDirSet() abort
  " check whether first buffer in project directory
  return isdirectory($IDE_DIR) && (empty(expand('%')) || stridx(expand('%:p'), getcwd()) != -1)
endfunction

function! project#setupAdditionalFeatures() abort
  " options
  set tags=./tags,tags,$IDE_DIR/tags,~/.local/share/tags

  " setup session configuration
  nn <silent> <leader>s :mksession! $IDE_DIR/session.vim <bar> echo 'Session saved'<CR>
  nn <silent> <leader>l :source $IDE_DIR/session.vim<CR>
  nn <silent> <leader>r :!rm $IDE_DIR/session.vim<CR><CR>:echo 'Session removed'<CR>

  " update ctags manually
  nn <silent> <leader>t :!updtags.sh $IDE_DIR/tags .<CR>
endfunction

function! project#tryReadLocalVimFile(filename) abort
  " NOTE: should be in the end to override previous options
  if filereadable($IDE_DIR.'/'.a:filename)
    exec 'source '.$IDE_DIR.'/'.a:filename
  endif
endfunction
