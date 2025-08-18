return {
	"zbirenbaum/copilot.lua",
	config = function()
		require("copilot").setup({
			suggestion = {
				enabled = false,
				debounce = 300,
			},
			panel = { enabled = false },
			server_opts_overrides = {
				advanced = {
					stops = { "\n\n" },
					top_p = 0.8,
					listCount = 2,
					inlineSuggestCount = 1,
				},
			},
		})
	end,
}
