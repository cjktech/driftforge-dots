local conf_int = require("config.internal").current
local groups = require("groups")
local M = {}

M.st_highlights = function()
	local highlights = {}
	for _, group in pairs(groups) do
		for hl, settings in pairs(group) do
			highlights[hl] = settings
		end
	end

	conf_int.on_highlights(highlights, conf_int.colors)

	for hl, settings in pairs(highlights) do
		vim.api.nvim_set_hl(0, hl, settings)
	end
end

return M
