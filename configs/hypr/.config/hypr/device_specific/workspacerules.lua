----------------------
--- WORKSPACERULES ---
----------------------

hl.workspace_rule({ workspace = "11", monitor = "DP-5", default = true })
hl.workspace_rule({ workspace = "21", monitor = "HDMI-A-2", default = true })
hl.workspace_rule({ workspace = "22" })
hl.workspace_rule({ workspace = "12" })


hl.workspace_rule({ workspace = "special:mail", on_created_empty = "thunderbird" })
hl.workspace_rule({ workspace = "special:discord", on_created_empty = "discord" })
hl.workspace_rule({ workspace = "special:spotify", on_created_empty = "spotify" })
hl.workspace_rule({ workspace = "special:browser", on_created_empty = "firefox" })
