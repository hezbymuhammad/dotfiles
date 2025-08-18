vim.cmd.colorscheme("catppuccin")
require("telescope").load_extension("fzf")

local servers = {
	gopls = {},
	golangci_lint_ls = {},
	ts_ls = {},
	eslint = {},
	cssls = {},
	html = {},
	jsonls = {},
	marksman = {},
	terraformls = {},
	yamlls = {},
	bashls = {},
}
local lspconfig = require("lspconfig")
for server, config in pairs(servers) do
	config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
	lspconfig[server].setup(config)
end

lspconfig.lua_ls.setup({
	capabilities = require("blink.cmp").get_lsp_capabilities({}),
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = {
					"vim",
					"require",
				},
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

lspconfig.ruby_lsp.setup({
	init_options = {
		formatter = "rubocop",
		linters = { "rubocop" },
	},
	capabilities = require("blink.cmp").get_lsp_capabilities({}),
})

vim.api.nvim_create_autocmd("User", {
	pattern = "BlinkCmpMenuOpen",
	callback = function()
		vim.b.copilot_suggestion_hidden = true
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "BlinkCmpMenuClose",
	callback = function()
		vim.b.copilot_suggestion_hidden = false
	end,
})

local backup_dir = vim.fn.expand("~/.local/nvim/backup")
if vim.fn.isdirectory(backup_dir) == 0 then
	vim.fn.system("mkdir -p " .. backup_dir)
end
vim.opt.backupdir = backup_dir
vim.opt.backup = true

local swap_dir = vim.fn.expand("~/.local/nvim/swap")
if vim.fn.isdirectory(swap_dir) == 0 then
	vim.fn.mkdir(swap_dir, "p")
end
vim.opt.directory = swap_dir

if vim.fn.exists("+undofile") == 1 then
	if vim.fn.isdirectory(vim.env.HOME .. "/.local/nvim/undo") == 0 then
		vim.fn.system("mkdir -p ~/.local/nvim/undo")
	end
	vim.opt.undodir = vim.env.HOME .. "/.local/nvim/undo"
	vim.opt.undofile = true
end
