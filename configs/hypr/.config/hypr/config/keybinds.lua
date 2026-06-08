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
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))

hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))

-- WORKSPACE CONTROL

--hl.bind(mainMod .. " + mouse_up", hl.dispatch({ direction = "left", action = "workspace"}))
--hl.bind(mainMod .. " + mouse_down", hl.dispatch({ direction = "right", action = "workspace" }))

-- find out how to emulate three finger touchpad swipe. Either by shell script or dispatcher

-- SPECIAL WORKSPACES

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("spotify"))
hl.bind(mainMod .. " + D", hl.dsp.workspace.toggle_special("discord"))
hl.bind(mainMod .. " + M", hl.dsp.workspace.toggle_special("mail"))
hl.bind(mainMod	.. " + B", hl.dsp.workspace.toggle_special("browser"))




-- AUDIO CONTROL

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
