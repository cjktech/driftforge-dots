-------------------
--- KEYBINDINGS ---
-------------------

local terminal    = "kitty"
local browser 	  = "firefox"
local fileManager = "thunar"
local menu        = "fuzzel"

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))

--hl.bind(mainMod .. " + mouse_up", hl.dsp.workspace.move({ workspace = "e+1", monitor = "HDMI-A-2"}))
--hl.bind(mainMod .. " + mouse_down", hl.dsp.workspace.move({ workspace = "e-1", monitor = "HDMI-A-2" }))

--hl.bind(mainMod .. " + 1", hl.workspace(1))
--hl.bind(mainMod .. " + 2", hl.workspace(2))
--hl.bind(mainMod .. " + 3", hl.workspace(3))
--hl.bind(mainMod .. " + 4", hl.workspace(4))
--hl.bind(mainMod .. " + 5", hl.workspace(5))
--hl.bind(mainMod .. " + 6", hl.workspace(6))
--hl.bind(mainMod .. " + 7", hl.workspace(7))
--hl.bind(mainMod .. " + 8", hl.workspace(8))
--hl.bind(mainMod .. " + 9", hl.workspace(9))

hl.bind(mainMod .. " + CTRL + S", hl.dsp.window.move({ workspace = "special:spotify" }))
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("spotify"))







-- AUDIO CONTROL

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
