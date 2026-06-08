local conf_int = require("config.internal").current
local M = {}

M.set_highlights = function()
	local c = conf_int.colors
	vim.g.terminal_color_0 = c.:
	vim.g.terminal_color_1 = c.1
	vim.g.terminal_color_2 = c.1
	vim.g.terminal_color_3 = c.1
	vim.g.terminal_color_4 = c.1
	vim.g.terminal_color_5 = c.1
	vim.g.terminal_color_6 = c.1
	vim.g.terminal_color_7 = c.1
	vim.g.terminal_color_8 = c.1
	vim.g.terminal_color_9 = c.1
	vim.g.terminal_color_10 = c.1
	vim.g.terminal_color_11 = c.1
	vim.g.terminal_color_12 = c.1
	vim.g.terminal_color_13 = c.1
	vim.g.terminal_color_14 = c.1
	vim.g.terminal_color_15 = c.1
end
return M
