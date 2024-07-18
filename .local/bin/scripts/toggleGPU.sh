#!/bin/bash

# NOTES:
# 1. if lock exists then nvidia enabled
# 2. to check that driver is working properly use command below
#   $ sudo lshw -c video | grep 'configuration'
#
# TODO: change way of using modules in /etc/modprobe.d/
#
# Links:
# https://unix.stackexchange.com/questions/334397/how-do-i-make-xorg-completely-ignore-one-of-my-display-adapters


[ "$EUID" -ne 0 ] && echo "Please run as root" && exit

nvidia_lock="/etc/nvidia_lock"

monitors_config="/etc/X11/xorg.conf.d/10-monitor.conf"
nvidia_module="/etc/modprobe.d/nvidia.conf"
nouveau_module="/etc/modprobe.d/nouveau.conf"
grub_config="/etc/default/grub"

xorg_conf=$(sed '0,/^XORGCONF$/d ; /^END_XORGCONF$/,$d' "$0")

grub_options="module_blacklist=nvidia,nvidia-current,nvidia_drm,nvidia_uvm,nvidia_modeset,nouveau"

make_backup() {
    file_path="$1"
    [ ! -f "$file_path" ] && return

    backup_path="$file_path.backup"
    echo "Backup '$file_path'"
    [ -f "$backup_path" ] &&\
        echo -n "Moving: " && mv -v "$backup_path" "$backup_path.1"
    echo -n "Copying: " && cp -v "$file_path" "$backup_path"
}

disable_nvidia() {
    echo "Disabling NVIDIA"

    # update x11 config
    rm "$nvidia_lock"

    make_backup "$monitors_config"
    echo "$xorg_conf" > "$monitors_config"
    sed -i "s/__GPU__/Intel/" "$monitors_config"

    # kernel modules blacklist
    echo "blacklist nouveau
blacklist lbm-nouveau
options nouveau modeset=0
alias nouveau off
alias lbm-nouveau off" > "$nouveau_module"
    echo "blacklist nvidia,nvidia-current,nvidia_drm,nvidia_uvm,nvidia_modeset" > "$nvidia_module"

    # update grub
    make_backup "$grub_config"
    sed -in "s/\(^GRUB_CMDLINE_LINUX_DEFAULT=.*\)\"$/\1 $grub_options\"/" "$grub_config"
    grub-mkconfig -o /boot/grub/grub.cfg
}

enable_nvidia() {
    echo "Enabling NVIDIA"

    # update x11 config
    touch "$nvidia_lock"

    make_backup "$monitors_config"
    echo "$xorg_conf" > "$monitors_config"
    sed -i "s/__GPU__/Nvidia/" "$monitors_config"

    rm -f "$nvidia_module" "$nouveau_module"

    # update grub
    make_backup "$grub_config"
    sed -in "s/\(^GRUB_CMDLINE_LINUX_DEFAULT=.*\) $grub_options\"$/\1\"/" "$grub_config"
    grub-mkconfig -o /boot/grub/grub.cfg
}

if [ -f "$nvidia_lock" ]; then
    disable_nvidia
else
    enable_nvidia
fi

exit

#############################################################################
XORGCONF
# vim: ft=xf86conf
# NOTE: man 5 xorg.conf

Section "ServerLayout"
    Identifier   "ServerLayout0"
    Screen     0 "Screen0"
    Option       "OffTime" "5"
EndSection

Section "Monitor"
    Identifier  "eDP1"
    Option      "DPMS"
EndSection

Section "Monitor"
    Identifier  "HDMI1"
    Option      "DPMS"
EndSection

# NOTE: man 4 intel
Section "Device"
    Identifier  "IntelCard"
    Driver      "intel"
    BusID       "PCI:0:2:0"
    Option      "TearFree"
EndSection

Section "Device"
    Identifier  "NvidiaCard"
    Driver      "nvidia"
    BusID       "PCI:1:0:0"
EndSection

Section "Screen"
    Identifier "Screen0"
    Device     "__GPU__Card"
    Monitor    "eDP1"
    DefaultDepth 24
EndSection
END_XORGCONF
#############################################################################
