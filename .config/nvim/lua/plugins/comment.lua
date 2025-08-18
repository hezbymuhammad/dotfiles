return {
	"numToStr/Comment.nvim",
	opts = {
		padding = true,
		sticky = true,
		ignore = nil,
		toggler = {},
		---LHS of operator-pending mappings in NORMAL and VISUAL mode
		opleader = {
			---Line-comment keymap
			line = "gc",
			---Block-comment keymap
			block = "gb",
		},
		---LHS of extra mappings
		extra = {
			---Add comment on the line above
			above = "gcO",
			---Add comment on the line below
			below = "gco",
			---Add comment at the end of line
			eol = "gcA",
		},
		mappings = {
			basic = false,
			---Extra mapping; `gco`, `gcO`, `gcA`
			extra = true,
		},
		pre_hook = nil,
		post_hook = nil,
	},
}
