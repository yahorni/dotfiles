#!/bin/bash

# NOTE: nvidia_lock sets in /nvidia_lock instead of XDG_DATA_HOME
# NOTE: do something with modules in /etc/modprobe.d/

[ "$EUID" -ne 0 ] && echo "Please run as root" && exit

nvidia_lock="$HOME/nvidia_lock"

monitors_config="/etc/X11/xorg.conf.d/10-monitor.conf"
nvidia_module="/etc/modprobe.d/nvidia.conf"
nouveau_module="/etc/modprobe.d/nouveau.conf"
grub_config="/etc/default/grub"

intel_cfg=$(sed '0,/^INTEL$/d ; /^END_INTEL$/,$d' "$0")
nvidia_cfg=$(sed '0,/^NVIDIA$/d ; /^END_NVIDIA$/,$d' "$0")

grub_options="module_blacklist=nvidia,nvidia-current,nvidia_drm,nvidia_uvm,nvidia_modeset,nouveau"

disable_nvidia() {
    echo "Disabling NVIDIA"

    # update x11 config
    rm "$nvidia_lock"
    echo "$intel_cfg" > "$monitors_config"

    # kernel modules blacklist
    echo "blacklist nouveau" > "$nouveau_module"
    echo "blacklist nvidia,nvidia-current,nvidia_drm,nvidia_uvm,nvidia_modeset" > "$nvidia_module"

    # update grub
    sed -in "s/\(^GRUB_CMDLINE_LINUX_DEFAULT=.*\)\"$/\1 $grub_options\"/" "$grub_config"
    grub-mkconfig -o /boot/grub/grub.cfg
}

enable_nvidia() {
    echo "Enabling NVIDIA"

    # update x11 config
    touch "$nvidia_lock"
    echo "$nvidia_cfg" > "$monitors_config"

    rm -f "$nvidia_module" "$nouveau_module"

    # update grub
    sed -in "s/\(^GRUB_CMDLINE_LINUX_DEFAULT=.*\) $grub_options\"$/\1\"/" "$grub_config"
    grub-mkconfig -o /boot/grub/grub.cfg
}

if [ -f "$nvidia_lock" ]; then # if nvidia enabled
    disable_nvidia
else # if disabled
    enable_nvidia
fi

exit

#############################################################################
INTEL
# vim: ft=xf86conf

Section "Device"
    Identifier "intel_gpu"
    Driver     "intel"
    Option     "TearFree" "true"
    BusID      "PCI:0:2:0"
EndSection

Section "Device"
    Identifier "nvidia_gpu"
    Driver     "nouveau"
    BusID      "PCI:1:0:0"
EndSection

Section "Monitor"
    Identifier "monitor"
    Option     "Primary" "true"
    Option     "DPMS" "true"
EndSection

Section "Screen"
    Identifier "intel_screen"
    Device     "intel_gpu"
    Monitor    "monitor"
EndSection

Section "ServerLayout"
    Identifier "intel_layout"
    Screen     "intel_screen"
    Option     "OffTime" "5"
    Inactive   "nvidia_gpu"
EndSection
END_INTEL
#############################################################################

#############################################################################
NVIDIA
# vim: ft=xf86conf

Section "Files"
    ModulePath "/usr/lib/nvidia"
    ModulePath "/usr/lib32/nvidia"
    ModulePath "/usr/lib32/nvidia/xorg/modules"
    ModulePath "/usr/lib32/xorg/modules"
    ModulePath "/usr/lib64/nvidia/xorg/modules"
    ModulePath "/usr/lib64/nvidia/xorg"
    ModulePath "/usr/lib64/xorg/modules"
EndSection

Section "Device"
    Identifier "intel_gpu"
    Driver     "modesetting"
    Option     "AccelMethod" "none"
    BusID      "PCI:0:2:0"
EndSection

Section "Device"
    Identifier "nvidia_gpu"
    Driver     "nvidia"
    BusID      "PCI:1:0:0"
EndSection

Section "Monitor"
    Identifier "monitor"
    Option     "Primary" "true"
    Option     "DPMS" "true"
EndSection

Section "Screen"
    Identifier "nvidia_screen"
    Device     "nvidia_gpu"
    Monitor    "monitor"
    DefaultDepth 24
    SubSection      "Display"
        Depth 24
    EndSubSection
EndSection

Section "ServerLayout"
    Identifier "nvidia_layout"
    Screen     "nvidia_screen"
    Option     "OffTime" "5"
    Inactive   "intel_gpu"
EndSection
END_NVIDIA
#############################################################################
