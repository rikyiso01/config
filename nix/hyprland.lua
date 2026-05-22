hl.monitor({
    output="eDP-1",
    mode="1920x1080@60",
    position="0x0",
    scale="1",
})
hl.monitor({
    output="",
    mode="preferred",
    position="auto",
    scale="1",
    mirror="eDP-1",
})
hl.monitor({
    output="desc:HP Inc. HP V22v G5 CNK4310DSG",
    mode="1920x1080@60",
    position="800x-1080",
    scale="1",
})
local terminal="/usr/bin/flatpak run page.codeberg.dnkl.foot"
local fileManager="/usr/bin/flatpak run org.gnome.Nautilus.Devel"
