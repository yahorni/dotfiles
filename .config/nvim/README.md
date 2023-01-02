# Vim/Neovim notes

## troubleshoot
+ After setting leader/localleader all mappings for them got removed
```vim
let mapleader=' '
let maplocalleader=','
```

## reformat file for linux/utf-8
```vim
set fileformat=unix fileencoding=utf-8
set ff=unix fenc=utf-8
```

## set tab width to other value (for example: 2)
```vim
set ts=2 | set sw=2 | set sts=2
au FileType sh setl ts=2 | setl sw=2 | setl sts=2
```

## disable expanding tabs to spaces
```vim
set noet
```

## modeline example
```
# vim:ft=vim:ts=4:sw=4:sts=4:fdm=marker:fdl=0:cms=#\ %s
```

## filename searching with spaces (32 is space symbol)
```vim
set isfname=@,48-57,/,.,-,_,+,,,#,$,%,~,=,32
```

## open nvim without config
```bash
nvim --clean                      # since v8
nvim -u DEFAULTS -U NONE -i NONE  # before v8
```

## vim-plug installation

1. vim
```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```
2. neovim
```bash
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```
3. after updating plugins in neovim - create link for vim
```bash
ln -s ~/.local/share/nvim/plugged ~/.vim/plugged
```
4. [optional] link vim setup for root
```bash
sudo mkdir -pv "/root/.local/share/nvim/{plugged,autoload}" "/root/.vim/"
sudo ln -s ~/.local/share/nvim/site/autoload /root/.local/share/nvim/site/autoload
sudo ln -s ~/.local/share/nvim/site/autoload /root/.vim/autoload
sudo ln -s ~/.local/share/nvim/plugged /root/.local/share/nvim/plugged
sudo ln -s ~/.local/share/nvim/plugged /root/.vim/plugged
```

## YCM installation
```bash
# don't forget to use corresponding gcc version
cd .vim/plugged/YouCompleteMe/
python3 install.py --clang-completer

# or this (in case previous option doesn't work)
python3 install.py --clangd-completer
```

## coc.nvim compilation
```bash
cd ~/.local/share/nvim/plugged/coc.nvim/
yarn install
yarn build
```

## pycscope installation (locally)
```bash
pip install git+https://github.com/portante/pycscope
```

## get script filename
```vim
" All of the above works OUTSIDE functions

" 1. script filename (relative)
echo expand('<sfile>')
" 2. script filename (absolute)
echo expand('<sfile>:p')
" 3. script filename (resolve symlinks)
echo resolve(expand('<sfile>'))
" 4. script directory
echo expand('<sfile>:p:h')
```
