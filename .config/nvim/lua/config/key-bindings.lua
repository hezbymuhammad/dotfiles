vim.api.nvim_set_keymap("n", "<C-\\>", ":NvimTreeToggle<cr>", { silent = true, noremap = true, desc = "Toggle tree" })
vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>", { desc = "Toggle source map" })

vim.api.nvim_set_keymap(
	"n",
	"<leader>fq",
	":TodoTelescope<cr>",
	{ silent = true, noremap = true, desc = "Find todo comments" }
)

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>\\", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fg", builtin.grep_string, { desc = "Telescope grep string" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

local gitsigns = require("gitsigns")
vim.keymap.set("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle line blame" })
vim.keymap.set("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "Toggle word diff" })

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	end,
})

vim.keymap.set(
	{ "n", "v" },
	"<leader>cc",
	"<cmd>CodeCompanionActions<cr>",
	{ noremap = true, silent = true, desc = "Toggle code codecompanion action" }
)

vim.keymap.set(
	{ "n", "v" },
	"<leader>ch",
	"<cmd>CodeCompanionHistory<cr>",
	{ noremap = true, silent = true, desc = "Toggle code codecompanion history list" }
)

vim.keymap.set(
	{ "n", "v" },
	"<leader>cs",
	"<cmd>CodeCompanionSummaries<cr>",
	{ noremap = true, silent = true, desc = "Toggle code codecompanion summary list" }
)

vim.keymap.set("n", "cp", function()
	local relative_path = vim.fn.fnamemodify(vim.fn.expand("%"), ":.")
	vim.fn.setreg("+", relative_path)
	vim.notify("Copied relative path: " .. relative_path)
end, { desc = "Copy current file relative path" })

local project_root = vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
vim.keymap.set("n", "<leader>cr", function()
	local function termcode(str)
		return vim.api.nvim_replace_termcodes(str, true, false, true)
	end
	vim.fn.feedkeys(":VectorCode register project_root=" .. project_root .. termcode("<CR>"), "n")
end, { desc = "Register vectorcode" })
