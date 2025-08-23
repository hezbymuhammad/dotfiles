return {
	"zbirenbaum/copilot.lua",
	config = function()
		require("copilot").setup({
			suggestion = {
				enabled = false,
				debounce = 700,
			},
			panel = { enabled = false },
			server_opts_overrides = {
				advanced = {
					stops = {
						"\n",
						"|endoftext|",
						"|im_end|",
					},
					top_p = 0.8,
					listCount = 2,
					inlineSuggestCount = 1,
				},
			},
		})
	end,
}
