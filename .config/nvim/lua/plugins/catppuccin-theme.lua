return {
  "catppuccin/nvim",
  lazy = true,
  name = "catppuccin",
  opts = {
    flavour = "mocha",
    integrations = {
      aerial = true,
      blink_cmp = true,
      barbar = true,
      gitsigns = true,
      telescope = { enabled = true },
      illuminate = { enabled = true },
      indent_blankline = { enabled = true },
      markdown = true,
      native_lsp = {
        enabled = true,
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
      treesitter = true,
      treesitter_context = true,
      which_key = true,
    },
  },
}
