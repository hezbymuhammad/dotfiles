return {
	"saghen/blink.cmp",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"fang2hou/blink-copilot",
		"zbirenbaum/copilot.lua",
		"milanglacier/minuet-ai.nvim",
	},

	build = "cargo build --release",
	opts = {
		keymap = {
			preset = "enter",
			["<C-n>"] = {
				function(cmp)
					cmp.show({ providers = { "copilot", "minuet" } })
				end,
				"fallback_to_mappings",
			},
		},

		appearance = {
			nerd_font_variant = "Nerd Font Mono",
			kind_icons = {
				claude = "󰋦 ",
				openai = "󱢆 ",
				codestral = "󱎥 ",
				gemini = " ",
				Groq = " ",
				Openrouter = "󱂇 ",
				Ollama = "󰳆 ",
				["Llama.cpp"] = "󰳆 ",
				Deepseek = " ",
			},
		},

		completion = {
			documentation = { auto_show = true },
			trigger = { prefetch_on_insert = false },
			ghost_text = {
				enabled = true,
				show_with_selection = false,
				show_without_selection = true,
				show_with_menu = true,
				show_without_menu = true,
			},
			list = {
				max_items = 20,
				selection = {
					preselect = false,
				},
			},
			menu = {
				draw = {
					columns = {
						{ "label", "label_description", gap = 1 },
						{ "kind_icon", "kind" },
						{ "source_icon" },
					},
					components = {
						source_icon = {
							ellipsis = false,
							text = function(ctx)
								return ctx.source_name:lower()
							end,
							highlight = "BlinkCmpSource",
						},
					},
				},
			},
		},

		sources = {
			default = { "copilot", "minuet", "lsp", "path", "snippets", "buffer", "codecompanion" },
			providers = {
				copilot = {
					name = "copilot",
					module = "blink-copilot",
					score_offset = 100,
					async = true,
				},
				minuet = {
					name = "minuet",
					module = "minuet.blink",
					async = true,
					timeout_ms = 1000,
					score_offset = 100,
				},
			},
		},

		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
