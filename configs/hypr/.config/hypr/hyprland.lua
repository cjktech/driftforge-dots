---------------------
---- MY PROGRAMS ----
---------------------




-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function ()
    hl.exec_cmd("waybar & mako")
end)


---------------------
---- KEYBINDINGS ----
---------------------





require("config.keybinds")
require("config.workspacerules")
require("config.windowrules")
require("config.monitors")
require("config.userprefs")


-----------------------
---- LOOK AND FEEL ----
-----------------------

local colors = require("theme.colors")
local color_active_border_1 = colors.brushed_zinc
local color_active_border_2 = colors.soft_brass
local color_inactive_border = colors.raised_black

hl.config({
    general = {
        gaps_in  = 3,
        gaps_out = 5,

        border_size = 2,

        col = {
            active_border   = { colors = {color_active_border_1, color_active_border_2}, angle = 45 },
            inactive_border = color_inactive_border,
        },

        resize_on_border = true,

        allow_tearing = true,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 18,
        rounding_power = 2,

        shadow = {
            enabled      = true,
	    range 	 = 18,
	    render_power = 3,
	    color 	 = "rgba(00000088)",
        },

        blur = {
            enabled  = true,
            size     = 5,
	    passes   = 2,
	    vibrancy = 0.03,
        },
    },

    animations = {
        enabled = true,
    },
})

