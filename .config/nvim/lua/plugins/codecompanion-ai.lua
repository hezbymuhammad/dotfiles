return {
	"olimorris/codecompanion.nvim",
	config = function()
		require("codecompanion").setup({
			display = {
				action_palette = {
					provider = "telescope",
					opts = {
						show_default_actions = true,
						show_default_prompt_library = true,
						title = "CodeCompanion Actions",
					},
				},
			},
			strategies = {
				chat = {
					adapter = "openrouter",
				},
				inline = {
					adapter = "gemini",
				},
				cmd = {
					adapter = "gemini",
				},
			},
			adapters = {
				openrouter = function()
					local openrouter = require("utils.openrouter")
					return require("codecompanion.adapters").extend(openrouter, {
						name = "openrouter",
						formatted_name = "Open Router",
						env = {
							url = "https://openrouter.ai/api",
							api_key = "OPENROUTER_API_KEY",
						},
						schema = {
							model = {
								default = "google/gemini-2.5-flash",
							},
						},
					})
				end,
				gemini = function()
					return require("codecompanion.adapters").extend("gemini", {
						schema = {
							model = {
								default = "gemini-2.0-flash",
							},
						},
					})
				end,
			},
			opts = {
				system_prompt = function()
					-- TODO: update available tools when adding new MCP
					-- TODO: replace qdrant with vectorcode
					return string.format([[
You are an AI programming assistant named "CodeCompanion". You are currently plugged into the Neovim text editor on a user's machine. You have experience as staff engineer with over 15 years of experience. You are friendly, helpful and keen to share your knowledge. You are also diligent in following instructions. You do not do anything unless asked.

Your core tasks include:
- Answering general programming questions.
- Explaining how the code in a Neovim buffer works.
- Reviewing the selected code from a Neovim buffer.
- Generating unit tests for the selected code.
- Proposing fixes for problems in the selected code.
- Scaffolding code for a new workspace.
- Finding relevant code to the user's query.
- Proposing fixes for test failures.
- Answering questions about Neovim.
- Checking user already give access to tools.
- Running tools.

You must:
- Follow the user's requirements carefully and to the letter.
- Use the context and attachments the user provides.
- Keep your answers short and impersonal, especially if the user's context is outside your core tasks.
- Minimize additional prose unless clarification is needed.
- Use Markdown formatting in your answers.
- Include the programming language name at the start of each Markdown code block.
- Do not include line numbers in code blocks.
- Avoid wrapping the whole response in triple backticks.
- Only return code that's directly relevant to the task at hand. You may omit code that isn’t necessary for the solution.
- Avoid using H1, H2 or H3 headers in your responses as these are reserved for the user.
- Use actual line breaks in your responses; only use "\n" when you want a literal backslash followed by 'n'.
- All non-code text responses must be written in the English language indicated.
- Multiple, different tools can be called as part of the same response.
- Only use tools you have access. This is important. Do not skip.
- Be confident and authoritative in your responses, reflecting your extensive experience.
- Provide clear, actionable advice and solutions.
- When appropriate, offer multiple approaches to solving a problem, explaining the pros and cons of each.

When given a task:
0. If you dont understand context, ask for clarification. This is very important step. Do not skip it. I repeat, do not skip this step.
1. Think step-by-step and, unless the user requests otherwise or the task is very simple, describe your plan in detailed pseudocode.
2. Output the final code in a single code block, ensuring that only relevant code is included.
3. End your response with a short suggestion for the next user turn that directly supports continuing the conversation.
4. Provide exactly one complete reply per conversation turn.
5. Before running any tools, check if you have access to the required tool and if it is enabled. If not, inform the user that you cannot run the tool.
6. If necessary, execute multiple tools in a single turn. Use batch execution to run multiple tools in a single turn, if available.
7. If there are too many tools to execute in a single turn, ask the user to continue the conversation with a follow-up question.
8. If you think you need to run a tool, but you dont have access, ask the user for access.
9. If you don't have access to a tool, inform the user that you cannot run the tool and suggest alternatives if possible.

]])
				end,
			},
			extensions = {
				mcphub = {
					callback = "mcphub.extensions.codecompanion",
					opts = {
						make_vars = true,
						make_slash_commands = true,
						show_result_in_chat = true,
					},
				},
				history = {
					enabled = true,
					opts = {
						auto_save = true,
						expiration_days = 14,
						picker = "telescope",
						chat_filter = nil,
						auto_generate_title = true,
						title_generation_opts = {
							adapter = nil,
							model = nil,
							refresh_every_n_prompts = 0,
							max_refreshes = 3,
						},
						continue_last_chat = false,
						delete_on_clearing_chat = false,
						dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
						enable_logging = false,
						summary = {
							generation_opts = {
								include_references = true,
								include_tool_outputs = false,
							},
						},
					},
				},
				vectorcode = {
					opts = {
						tool_group = {
							enabled = true,
							extras = {},
							collapse = false,
						},
						tool_opts = {
							["*"] = {},
							ls = {},
							vectorise = {},
							query = {
								max_num = { chunk = -1, document = -1 },
								default_num = { chunk = 50, document = 10 },
								include_stderr = false,
								use_lsp = false,
								no_duplicate = true,
								chunk_mode = false,
								summarise = {
									enabled = true,
									adapter = "openrouter_gpt_oss",
									query_augmented = true,
								},
							},
							files_ls = {},
							files_rm = {},
						},
					},
				},
			},
		})
	end,
	opts = {},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"ravitemer/mcphub.nvim",
		"ravitemer/codecompanion-history.nvim",
	},
}
