---@module 'hl'

local fileManager = "/usr/bin/flatpak run org.gnome.Nautilus.Devel"

local mainMod = "SUPER"

local menu = "XDG_DATA_DIRS=/home/riky/.local/share/flatpak/exports/share /nix/store/32iwmf6ipnxnnzcvmlrnxdbk1x1cq3qc-fuzzel-1.14.1/bin/fuzzel"

local terminal = "/usr/bin/flatpak run page.codeberg.dnkl.foot"

hl.config({
    animations = {
        enabled = true,
    },
})

hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
hl.animation({leaf="windows", enabled=true, speed=7, bezier="myBezier"})
hl.animation({leaf="windowsOut", enabled=true, speed=7, bezier="default", style="popin 80%"})
hl.animation({leaf="border", enabled=true, speed=10, bezier="default"})
hl.animation({leaf="fade", enabled=true, speed=7, bezier="default"})
hl.animation({leaf="workspaces", enabled=1, speed=6, bezier="default"})

hl.bind(mainMod .. " + " .. "RETURN", hl.dsp.exec_cmd(terminal))

hl.bind(mainMod .. " + " .. "Q", hl.dsp.window.close())

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "P", hl.dsp.exec_cmd("poweroff"))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "F", hl.dsp.exec_cmd("if [[ $(powerprofilesctl get)='power-saver' ]]; then powerprofilesctl set balanced; else powerprofilesctl set power-saver; fi"))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "W", hl.dsp.exec_cmd("pkill hyprpaper"))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "B", hl.dsp.exec_cmd("rfkill toggle bluetooth"))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "R", hl.dsp.exec_cmd("nmcli d wifi rescan"))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "G", hl.dsp.exec_cmd("/usr/bin/hyprlock"))

hl.bind(mainMod .. " + " .. "E", hl.dsp.exec_cmd(fileManager))

hl.bind(mainMod .. " + " .. "V", hl.dsp.window.float())

hl.bind(mainMod .. " + " .. "R", hl.dsp.exec_cmd(menu))

hl.bind(mainMod .. " + " .. "P", hl.dsp.window.pseudo())

hl.bind(mainMod .. " + " .. "H", hl.dsp.layout("cycleprev"))

hl.bind(mainMod .. " + " .. "L", hl.dsp.layout("cyclenext"))

hl.bind(mainMod .. " + " .. "K", hl.dsp.layout("cycleprev"))

hl.bind(mainMod .. " + " .. "J", hl.dsp.layout("cyclenext"))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "H", hl.dsp.layout("swapprev"))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "L", hl.dsp.layout("swapnext"))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "K", hl.dsp.layout("swapprev"))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "J", hl.dsp.layout("swapnext"))

hl.bind(mainMod .. " + " .. "CONTROL" .. " + " .. "H", hl.dsp.focus({workspace="+1"}))

hl.bind(mainMod .. " + " .. "CONTROL" .. " + " .. "L", hl.dsp.focus({workspace="-1"}))

-- TODO: manual review (unknown dispatcher: movecurrentworkspacetomonitor)
hl.bind(mainMod .. " + " .. "SHIFT + CONTROL" .. " + ".."H", hl.dsp.workspace.move({monitor="+1"}))

-- TODO: manual review (unknown dispatcher: movecurrentworkspacetomonitor)
hl.bind(mainMod .. " + " .. "SHIFT + CONTROL" .." + ".. "L", hl.dsp.workspace.move({monitor="-1"}))

hl.bind(mainMod .. " + " .. 1, hl.dsp.focus({ workspace = 1 }))

hl.bind(mainMod .. " + " .. 2, hl.dsp.focus({ workspace = 2 }))

hl.bind(mainMod .. " + " .. 3, hl.dsp.focus({ workspace = 3 }))

hl.bind(mainMod .. " + " .. 4, hl.dsp.focus({ workspace = 4 }))

hl.bind(mainMod .. " + " .. 5, hl.dsp.focus({ workspace = 5 }))

hl.bind(mainMod .. " + " .. 6, hl.dsp.focus({ workspace = 6 }))

hl.bind(mainMod .. " + " .. 7, hl.dsp.focus({ workspace = 7 }))

hl.bind(mainMod .. " + " .. 8, hl.dsp.focus({ workspace = 8 }))

hl.bind(mainMod .. " + " .. 9, hl.dsp.focus({ workspace = 9 }))

hl.bind(mainMod .. " + " .. 0, hl.dsp.focus({ workspace = 10 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 1, hl.dsp.window.move({ workspace = 1 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 2, hl.dsp.window.move({ workspace = 2 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 3, hl.dsp.window.move({ workspace = 3 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 4, hl.dsp.window.move({ workspace = 4 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 5, hl.dsp.window.move({ workspace = 5 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 6, hl.dsp.window.move({ workspace = 6 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 7, hl.dsp.window.move({ workspace = 7 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 8, hl.dsp.window.move({ workspace = 8 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 9, hl.dsp.window.move({ workspace = 9 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 0, hl.dsp.window.move({ workspace = 10 }))

hl.bind(mainMod .. " + " .. "S", hl.dsp.workspace.toggle_special("magic"))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + " .. "mouse_down", hl.dsp.focus({ workspace = "e+1" }))

hl.bind(mainMod .. " + " .. "mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("/nix/store/pvknspwg9hj14p9w0dz9h5vkafnfrgzf-pamixer-1.6/bin/pamixer -i 5"))

hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("/nix/store/pvknspwg9hj14p9w0dz9h5vkafnfrgzf-pamixer-1.6/bin/pamixer -d 5"))

hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("/nix/store/pvknspwg9hj14p9w0dz9h5vkafnfrgzf-pamixer-1.6/bin/pamixer --default-source -t"))

hl.bind("XF86AudioMute", hl.dsp.exec_cmd("/nix/store/pvknspwg9hj14p9w0dz9h5vkafnfrgzf-pamixer-1.6/bin/pamixer -t"))

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("/nix/store/sjg89qr56dhim29grl015v7jmhyxc2hg-playerctl-2.4.1/bin/playerctl -a play-pause"))

hl.bind("XF86AudioPause", hl.dsp.exec_cmd("/nix/store/sjg89qr56dhim29grl015v7jmhyxc2hg-playerctl-2.4.1/bin/playerctl -a play-pause"))

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("/nix/store/sjg89qr56dhim29grl015v7jmhyxc2hg-playerctl-2.4.1/bin/playerctl -a next"))

hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("/nix/store/sjg89qr56dhim29grl015v7jmhyxc2hg-playerctl-2.4.1/bin/playerctl -a previous"))

hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("/nix/store/ghfvmywa3hp31f2pglr2d39iy8b7hgai-brightnessctl-0.5.1/bin/brightnessctl set 5%-"))

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("/nix/store/ghfvmywa3hp31f2pglr2d39iy8b7hgai-brightnessctl-0.5.1/bin/brightnessctl set 5%+"))

hl.bind("Print", hl.dsp.exec_cmd("/nix/store/srpb3hblarmk1kkshd9dy3nb2iw3z6gq-grim-1.5.0/bin/grim \"$(/nix/store/3kygggbgdpql9z8wyicwjy31cz76qmcg-xdg-user-dirs-0.20/bin/xdg-user-dir PICTURES)/$(date +'%s_grim.png')\""))

hl.bind("XF86HomePage", hl.dsp.exec_cmd("/nix/store/ghfvmywa3hp31f2pglr2d39iy8b7hgai-brightnessctl-0.5.1/bin/brightnessctl set 5%-"))

hl.bind("XF86Mail", hl.dsp.exec_cmd("/nix/store/ghfvmywa3hp31f2pglr2d39iy8b7hgai-brightnessctl-0.5.1/bin/brightnessctl set 5%+"))

hl.bind(mainMod .. " + " .. "F", hl.dsp.window.fullscreen({mode="fullscreen"}))

hl.bind(mainMod .. " + " .. "M", hl.dsp.window.fullscreen({mode="maximized"}))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "M", hl.dsp.exec_cmd("/nix/store/pvknspwg9hj14p9w0dz9h5vkafnfrgzf-pamixer-1.6/bin/pamixer --default-source -t"))

hl.bind(mainMod .. " + " .. "mouse:272", hl.dsp.window.drag(), { mouse = true })

hl.bind(mainMod .. " + " .. "mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.config({
    decoration = {
        blur = {
            enabled = false,
            passes = 1,
            size = 3,
        },
        shadow = {
            enabled = false,
        },
        rounding = 10,
    },
})

hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.500000,
})

hl.device({
    name = "cx-trust-wireless-mouse-1",
    sensitivity = -0.250000,
})

hl.config({
    dwindle = {
        preserve_split = true,
    },
})

hl.env("XCURSOR_SIZE", 36)

hl.env("XCURSOR_THEME", "Bibata-Modern-Amber")




hl.config({
    general = {
        allow_tearing = false,
        border_size = 2,
        gaps_in = 0,
        gaps_out = 0,
        layout = "master",
        col = {
            active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
    },
})

hl.config({
    input = {
        touchpad = {
            natural_scroll = true,
        },
        follow_mouse = 1,
        kb_layout = "us",
        kb_options = "ctrl:nocaps, compose:paus",
        repeat_delay = 300,
        repeat_rate = 50,
        sensitivity = 1.000000,
    },
})

hl.config({
    misc = {
        disable_watchdog_warning = true,
        force_default_wallpaper = 0,
        on_focus_under_fullscreen = true,
    },
})

hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@60",
    position = "0x0",
    scale    = 1,
})

hl.monitor({
    output   = "desc:HP Inc. HP V22v G5 CNK4310DSG",
    mode     = "1920x1080@60",
    position = "800x-1080",
    scale    = 1,
})

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})

-- Autostart
hl.on("hyprland.start", function()
    hl.exec_cmd("/usr/libexec/hyprpolkitagent")
    hl.exec_cmd("[workspace 1 silent; maximize] /usr/bin/flatpak run page.codeberg.dnkl.foot")
    hl.exec_cmd("[workspace 2 silent; no_initial_focus] sleep 5 && /usr/bin/flatpak run io.gitlab.librewolf-community")
    hl.exec_cmd("secret-tool lookup keepass password | SSH_AUTH_SOCK=" .. os.getenv("XDG_RUNTIME_DIR") .. "/gcr/ssh /usr/bin/flatpak run --file-forwarding org.keepassxc.KeePassXC --pw-stdin @@ /home/riky/backup/phone/Drive/keepass.kdbx @@")
    hl.exec_cmd("/nix/store/z3rcmw3jr4wgdsqmjibmz26hdpbmv89i-handle-monitor.sh")
end)

