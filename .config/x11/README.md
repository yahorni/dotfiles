# X11 notes

## autostart

### systemd services

```bash
# system
systemctl enable --now bluetooth

# user
systemctl --user enable mpd
systemctl --user enable mpd-mpris
systemctl --user enable acpi-volume
```

This should probably fix `DISPLAY` variable: `/etc/X11/xinit/xinitrc.d/50-systemd-user.sh`
But I haven't see it working. Manual command: `systemctl --user import-environment DISPLAY XAUTHORITY`
For failing systemd service use: `systemctl --user reset-failed greenclip`
Or add `RestartSec=5s` to the service to not die too quickly

1. **transmission**
   <https://wiki.archlinux.org/title/Transmission#Choosing_a_user>
   - command: `systemctl enable transmission.service`
2. **powertop**
   <https://wiki.archlinux.org/title/Powertop#Apply_settings>
   - command: `systemctl enable powertop.service`
3. **syncthing**
   - command: `systemctl --user enable syncthing.service`
4. **greenclip**
   - fixing instant crash (this or manual command above)
     1. open: `/usr/lib/systemd/user/greenclip.service`
     2. comment `After=display-manager.service` (same for redshift)
     3. create `~/.config/systemd/user/greenclip.service.d/display.conf` and put lines below there:
     (can be created command: `systemctl --user edit greenclip`)
     ```dosini
         [Service]
         Environment=DISPLAY=:0
     ```
   - command: `systemctl --user enable --now greenclip.service`
5. **redshift**
   - same `display.conf` fix as for **greenclip** or manual command above
   - <https://wiki.archlinux.org/title/Redshift#Specify_location_manually>
   - command `systemctl --user enable --now redshift.service`
6. **playerctld**
   - same `display.conf` fix as for **greenclip** or manual command above
   - service file taken from: <https://wiki.archlinux.org/title/MPRIS#Playerctl>
     path `~/.config/systemd/user/playerctld.service`
     added: `ExecStop=/usr/bin/pkill -f playerctld`
   - command: `systemctl --user enable --now playerctld.service`
7. **clipmenu**
  ```bash
  cp ~/.local/lib/systemd/user/clipmenud.service ~/.config/systemd/user/
  systemctl --user enable --now clipmenud.service
  ```

### nvidia drivers

```bash
# nvidia card hacks to work on laptop
if lsmod | grep "nvidia" ; then
    xrandr --setprovideroutputsource modesetting NVIDIA-0
    xrandr --auto

    # configure dpi
    xrandr --dpi 96
fi
```

## startx

- path for xsessions: `/usr/share/xsessions/`
- scripts which run xsession
  - `/etc/X11/xinit/Xsession` - centos_7
  - `/etc/X11/Xsession` - ubuntu_18
- display configuration: `/usr/share/X11/xorg.conf.d/`

### dwm xsession with display manager

1. put `dwm.desktop` to `/usr/share/xsessions`
2. set acceptable `Exec` (dwm/dwm-run/...)
3. edit `~/.config/shell/profile` (and `~/.config/shell/on_login` if needed)
    - variables: `WM`, `WM_ARGS`, `WM_BAR`
    - variable `USE_XSESSION='true'`
4. make symlink for needed profile to `~/.config/shell/xprofile.sh`
5. make `~/.xinitrc` and `~/.config/shell/profile.sh` executable
6. make symlink `~/.profile` -> `~/.config/shell/profile.sh` (for gdm on ubuntu_18)

### gnome 3 from gdm on centos 7

```bash
export USE_XSESSION='true'
export WM='gnome-session'
export WM_ARGS='--session gnome-classic'
export WM_BAR=
```

### dwm from gdm on ubuntu 18

```bash
export USE_XSESSION='true'
export WM='dwm'
export WM_ARGS=
export WM_BAR=
```
