local M = {}

local DEFAULT_SETTINGS = {

	transparent = false,
	bold = true,
	italic = true,

	on_highlights = function(highlights, colors) end,
	colors = {
		bg = "#040506",
		inactiveBg = "#040506",
		fg = "#c7d0d9",
		floatBorder = "#ffffff",
		line = "#0B0E11",
		comment = "#425261",
		func = "#a3320b",
		string = "#2d669f",
		number = "#3170af",
		property = "#ba6b26",
		constant = "#d98a45",
		parameter = "#88e7d1",
		visual = "#181F25",
		error = "#bf3a0d",
		warning = "#d2b07b",
		hint = "#2f9d94",
		operator = "#aab8c5",
		keyword = "#baf2e5",
		type = "#b6c2cd",
		search = "#774418",
		plus = "#4a6741",
		delta = "#d2b07b",
	},
}

M._DEFAULT_SETTINGS = DEFAULT_SETTINGS
M.current = M._DEFAULT_SETTINGS

local opts = type(vim.g.driftforge_colorscheme) == "function" and vim.g.driftforge_colorscheme() or vim.g.driftforge_colorscheme or {}

M.set = function(user_opts) M.current = vim.tbl_deep_extend("force", vim.deepcopy(M.current), user_opts or pots) end

return M
