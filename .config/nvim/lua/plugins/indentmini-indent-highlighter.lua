return {
	"nvimdev/indentmini.nvim",
	config = function()
		require("indentmini").setup({
			only_current = true,
		})
	end,
}
