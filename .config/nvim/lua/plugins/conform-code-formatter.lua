return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			python = { "isort", "black", "trim_whitespace" },
			javascript = { "eslint_d", "prettierd", "trim_whitespace" },
			typescript = { "eslint_d", "prettierd", "trim_whitespace" },
			go = { "goimports", "gofmt", "trim_whitespace" },
			rust = { "rustfmt", "trim_whitespace" },
			ruby = { "rubocop", "trim_whitespace" },
			json = { "jq", "trim_whitespace" },
			css = { lsp_format = "prefer", "trim_whitespace" },
			html = { lsp_format = "prefer", "trim_whitespace" },
			sh = { lsp_format = "prefer" },
			bash = { lsp_format = "prefer" },
			terraform = { lsp_format = "prefer", "trim_whitespace" },
			yaml = { lsp_format = "prefer", "trim_whitespace" },
			markdown = { "prettierd", "trim_whitespace" },
			lua = { "stylua", "trim_whitespace" },
		},
		default_format_opts = {
			lsp_format = "never",
		},
		format_on_save = { timeout_ms = 2000 },
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
