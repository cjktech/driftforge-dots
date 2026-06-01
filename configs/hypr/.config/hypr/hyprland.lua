-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function ()
    hl.exec_cmd("waybar")
    hl.exec_cmd("mako")
    hl.exec_cmd("sunshine")
end)

require("config.keybinds")
require("config.windowrules")
require("config.userprefs")
require("config.design")
require("config.layout")

require("device_specific.workspacerules")
require("device_specific.monitors")
