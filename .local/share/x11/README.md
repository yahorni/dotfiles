# X11 notes

## path for xsessions
"/usr/share/xsessions/"

## scripts which run xsession
+ "/etc/X11/xinit/Xsession"     (centos_7)
+ "/etc/X11/Xsession"           (ubuntu_18)

## display configuration
+ "/usr/share/X11/xorg.conf.d/"

## algorithm
1. put dwm.desktop to "/usr/share/xsessions"
2. set acceptable "Exec" (dwm/dwm-run/...)
3. edit "~/.config/shell/profile" (and "~/.config/shell/on_login" if needed)
    + variables: WM, WM_ARGS, WM_BAR
    + variable USE_XSESSION='true'
4. make symlink for needed profile to "~/.config/shell/xprofile.sh"
5. make "~/.xinitrc" and "~/.config/shell/profile.sh" executable
6. make symlink "~/.profile" -> "~/.config/shell/profile.sh" (for gdm on ubuntu_18)

## run gnome 3 from gdm on centos 7
```bash
export USE_XSESSION='true'
export WM='gnome-session'
export WM_ARGS='--session gnome-classic'
export WM_BAR=
```

## run dwm from gdm on ubuntu 18
```bash
export USE_XSESSION='true'
export WM='dwm'
export WM_ARGS=
export WM_BAR=
```
