---@module 'hl'

local home = os.getenv("HOME")
local fileManager = "/usr/bin/flatpak run org.gnome.Nautilus.Devel"

local mainMod = "SUPER"

local terminal = "/usr/bin/flatpak run page.codeberg.dnkl.foot"

local ipc = "noctalia msg "

hl.config({
	general = {
		allow_tearing = false,
		border_size = 2,
		gaps_in = 5,
		gaps_out = 10,
		layout = "master",
		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},
	},
	animations = {
		enabled = true,
	},
	decoration = {
		blur = {
			enabled = true,
			passes = 2,
			size = 3,
			vibrancy = 0.1696,
		},
		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "0xee1a1a1a",
		},
		rounding = 20,
		rounding_power = 2,
	},
	dwindle = {
		preserve_split = true,
	},
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
	misc = {
		disable_watchdog_warning = true,
		force_default_wallpaper = 0,
		on_focus_under_fullscreen = true,
	},
})

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = 1, speed = 6, bezier = "default" })

hl.bind(mainMod .. " + " .. "RETURN", hl.dsp.exec_cmd(terminal))

hl.bind(mainMod .. " + " .. "Q", hl.dsp.window.close())

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "P", hl.dsp.exec_cmd("poweroff"))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "F", hl.dsp.exec_cmd(ipc .. "power-cycle"))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "W", hl.dsp.exec_cmd(ipc .. "wallpaper-next"))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "B", hl.dsp.exec_cmd(ipc .. "bluetooth-toggle"))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "G", hl.dsp.exec_cmd(ipc .. "session lock"))

hl.bind(mainMod .. " + " .. "E", hl.dsp.exec_cmd(fileManager))

hl.bind(mainMod .. " + " .. "V", hl.dsp.window.float())

hl.bind(mainMod .. " + " .. "R", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))

hl.bind(mainMod .. " + " .. "P", hl.dsp.window.pseudo())

hl.bind(mainMod .. " + " .. "H", hl.dsp.layout("cycleprev"))

hl.bind(mainMod .. " + " .. "L", hl.dsp.layout("cyclenext"))

hl.bind(mainMod .. " + " .. "K", hl.dsp.layout("cycleprev"))

hl.bind(mainMod .. " + " .. "J", hl.dsp.layout("cyclenext"))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "H", hl.dsp.layout("swapprev"))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "L", hl.dsp.layout("swapnext"))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "K", hl.dsp.layout("swapprev"))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "J", hl.dsp.layout("swapnext"))

hl.bind(mainMod .. " + " .. "CONTROL" .. " + " .. "H", hl.dsp.focus({ workspace = "+1" }))

hl.bind(mainMod .. " + " .. "CONTROL" .. " + " .. "L", hl.dsp.focus({ workspace = "-1" }))

-- TODO: manual review (unknown dispatcher: movecurrentworkspacetomonitor)
hl.bind(mainMod .. " + " .. "SHIFT + CONTROL" .. " + " .. "H", hl.dsp.workspace.move({ monitor = "+1" }))

-- TODO: manual review (unknown dispatcher: movecurrentworkspacetomonitor)
hl.bind(mainMod .. " + " .. "SHIFT + CONTROL" .. " + " .. "L", hl.dsp.workspace.move({ monitor = "-1" }))

for i = 1, 9 do
	hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. i, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + " .. "S", hl.dsp.workspace.toggle_special("magic"))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + " .. "mouse_down", hl.dsp.focus({ workspace = "e+1" }))

hl.bind(mainMod .. " + " .. "mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume-up"))

hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume-down"))

hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(ipc .. "mic-mute"))

hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "volume-mute"))

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(ipc .. "media toggle"))

hl.bind("XF86AudioPause", hl.dsp.exec_cmd(ipc .. "media toggle"))

hl.bind("XF86AudioNext", hl.dsp.exec_cmd(ipc .. "media next"))

hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(ipc .. "media previous"))

hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. "brightness-down"))

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. "brightness-up"))

hl.bind("Print", hl.dsp.exec_cmd(ipc .. "screenshot-region"))

hl.bind(mainMod .. " + " .. "F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

hl.bind(mainMod .. " + " .. "M", hl.dsp.window.fullscreen({ mode = "maximized" }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "M", hl.dsp.exec_cmd(ipc .. "mic-mute"))

hl.bind(mainMod .. " + " .. "mouse:272", hl.dsp.window.drag(), { mouse = true })

hl.bind(mainMod .. " + " .. "mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.500000,
})

hl.device({
	name = "cx-trust-wireless-mouse-1",
	sensitivity = -0.250000,
})

hl.env("XCURSOR_SIZE", 36)

hl.env("XCURSOR_THEME", "Bibata-Modern-Amber")

hl.monitor({
	output = "eDP-1",
	mode = "1920x1080@60",
	position = "0x0",
	scale = 1,
})

hl.monitor({
	output = "desc:HP Inc. HP V22v G5 CNK4310DSG",
	mode = "1920x1080@60",
	position = "800x-1080",
	scale = 1,
})

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = 1,
})

hl.window_rule({
	match = { class = "dev.noctalia.Noctalia" },
	float = true,
	size = { 1080, 920 },
})

hl.layer_rule({
	name = "noctalia",
	match = {
		namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
	},
	no_anim = true,
	ignore_alpha = 0.5,
	blur = true,
	blur_popups = true,
})

-- Autostart
hl.on("hyprland.start", function()
	hl.exec_cmd("[workspace 1 silent; maximize] /usr/bin/flatpak run page.codeberg.dnkl.foot")
	hl.exec_cmd("[workspace 2 silent; no_initial_focus] sleep 5 && /usr/bin/flatpak run io.gitlab.librewolf-community")
	hl.exec_cmd(
		"secret-tool lookup keepass password | SSH_AUTH_SOCK="
			.. os.getenv("XDG_RUNTIME_DIR")
			.. "/gcr/ssh /usr/bin/flatpak run --file-forwarding org.keepassxc.KeePassXC --pw-stdin @@ "
			.. home
			.. "/backup/phone/Drive/keepass.kdbx @@"
	)
	hl.exec_cmd("LC_TIME=en_GB nixGLIntel noctalia")
end)

hl.on("monitor.added", function(monitor)
	for i = 2, 5 do
		hl.dispatch(hl.dsp.workspace.move({ workspace = i, monitor = monitor }))
	end
end)
