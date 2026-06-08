--------------
--- DESIGN ---
--------------

local colors = dofile(os.getenv("HOME") .. "/.config/theme/hypr/colors.lua")

hl.curve("snap", { type = "bezier", points = {{ 0.05, 0.9 }, { 0.1, 1.0 }} })
hl.curve("deliberate", { type = "bezier", points = {{ 0.25, 0.85}, { 0.1,  1.0 }} })

hl.animation({ leaf = "windows", enabled = true, speed = 2, bezier = "snap", style = "popin"})
hl.animation({ leaf = "border", enabled = true, speed = 3, bezier =  "snap"})
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 4, bezier = "deliberate", style = "fade"})
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 4, bezier ="deliberate", style = "slide"})
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4, bezier = "deliberate", style = "fade"})


hl.config({
    general = {
        gaps_in  = 3,
        gaps_out = 5,
	border_size = 2,

        col = {
            active_border   = { colors = { colors.border_active_1, colors.border_active_2 }, angle = 45 },
            inactive_border = colors.border_inactive,
        },

        resize_on_border = true,
        allow_tearing    = true,
    },
	
    decoration = {
	rounding       = 18,
	rounding_power = 2,

        shadow = {
	    enabled      = true,
            range        = 18,
            render_power = 3,
            color        = colors.soft_overlay,
        },

        blur = {
            enabled  = true,
            size     = 5,
            passes   = 2,
            vibrancy = 0.03,
        },
    },
})
