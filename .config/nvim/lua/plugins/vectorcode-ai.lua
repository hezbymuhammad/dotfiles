return {
	"Davidyz/VectorCode",
	version = "*",
	build = "uv tool upgrade vectorcode",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		n_query = 2,
	},
}
