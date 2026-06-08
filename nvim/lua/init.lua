local conf_int = require("config.internal")
local M = {}

M.setup = function(user_opts)
	if user_opts then conf_int.set(user_opts) end
end

M.get_palette = function()
	local palette = {}
	for name, color in pairs(conf_int.current.colors) do
		palette[name] = color
	end
	return palette
end

M._colorscheme = function()
	vim.cmd("highlight clear")
	if vim.fn.has("syntax_on") then vim.cmd("syntax reset") end
	vim.g.colors_name = "driftforge"

	require("highlights").set_highlights()
	require("terminal").set_highlights()
end

return M
