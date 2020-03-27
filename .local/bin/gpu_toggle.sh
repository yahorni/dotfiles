#!/bin/sh

nvidia_lock="$XDG_DATA_HOME/nvidia_lock"
monitors_config="/etc/X11/xorg.conf.d/10-monitor.conf"

intel_cfg=`sed '0,/^INTEL$/d ; /^END_INTEL$/,$d' "$0"`
nvidia_cfg=`sed '0,/^NVIDIA$/d ; /^END_NVIDIA$/,$d' "$0"`

if [ -f "$nvidia_lock" ]; then # if nvidia enabled
    echo "Disabling NVIDIA"
    rm "$nvidia_lock"
    sudo echo "$intel_cfg" > "$monitors_config"
else # if disabled
    echo "Enabling NVIDIA"
    touch "$nvidia_lock"
    sudo echo "$nvidia_cfg" > "$monitors_config"
fi

exit

#############################################################################
# vim: ft=xf86conf

INTEL
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
