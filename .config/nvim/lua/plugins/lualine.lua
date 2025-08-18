return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"franco-ruggeri/codecompanion-lualine.nvim",
		"AndreM222/copilot-lualine",
	},
	config = function()
		require("evil_lualine")
	end,
}
