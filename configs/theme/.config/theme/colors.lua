--------------
--- COLORS ---
--------------

local colors = {
	pure_black 	   = "rgba(040506FF)",
	soft_black 	   = "rgba(0B0E11FF)",
	main_black	   = "rgba(11161CFF)",
	raised_black 	   = "rgba(161D24FF)",

	deep_alloy 	   = "rgba(6E7781FF)",
	brushed_zinc	   = "rgba(A7B1BAFF)",
	polished_zinc	   = "rgba(C7D0D9FF)",
	frosted_metallic   = "rgba(D6DEE6FF)",

	soft_brass 	   = "rgba(B08D57FF)",
	highlight_brass    = "rgba(C9A46AFF)",
	bright_edge_brass  = "rgba(D2B07BFF)",

	frost_white 	   = "rgba(EAF2F8FF)",
	cold_white	   = "rgba(DCEBFFFF)",
	metallic_highlight = "rgba(F4F8FCFF)",

	transparent_black  = "rgba(0B0E11CC)",
	deep_glass	   = "rgba(11161CD9)",
	soft_overlay	   = "rgba(040506B3)",
}

-------------------
--- ASSIGNMENTS ---
-------------------

-- Backgrounds
colors.background        = colors.main_black
colors.background_raised = colors.raised_black
colors.surface_glass     = colors.deep_glass
colors.surface_overlay   = colors.soft_overlay
colors.surface_dim       = colors.transparent_black

-- Window borders
colors.border_active_1   = colors.brushed_zinc
colors.border_active_2   = colors.soft_brass
colors.border_inactive   = colors.raised_black

-- Text
colors.text_primary      = colors.polished_zinc
colors.text_secondary    = colors.brushed_zinc
colors.text_muted        = colors.deep_alloy

-- Accents
colors.accent_primary    = colors.highlight_brass
colors.accent_secondary  = colors.soft_brass
colors.highlight_pop     = colors.metallic_highlight

return colors
