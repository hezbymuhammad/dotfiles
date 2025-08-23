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
					variables = {
						["vectorcode"] = {
							callback = function()
								local rag_context = ""

								local has_vc, vectorcode_config = pcall(require, "vectorcode.config")
								local vectorcode_cacher = nil
								if has_vc then
									vectorcode_cacher = vectorcode_config.get_cacher_backend()
								end

								-- roughly equate to 2000 tokens for LLM
								local RAG_Context_Window_Size = 8000

								if has_vc and vectorcode_cacher ~= nil then
									local cache_result = vectorcode_cacher.query_from_cache(0)
									for _, file in ipairs(cache_result) do
										rag_context = rag_context
											.. "<file_separator>"
											.. file.path
											.. "\n"
											.. file.document
									end
								end

								rag_context = vim.fn.strcharpart(rag_context, 0, RAG_Context_Window_Size)
								if rag_context ~= "" then
									rag_context = "To help you assist with my user prompt, I'm attaching the contents of a repo context:\n"
										.. "<repo_context>\n"
										.. rag_context
										.. "\n</repo_context>"
								end

								return rag_context
							end,
							description = "Use vectorcode",
							opts = {
								contains_code = true,
							},
						},
					},
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
- Use the context, repo_context and attachments the user provides.
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
- Think step-by-step and, unless the user requests otherwise or the task is very simple.
- Never give vague answers and solutions. If the ask or question is broad, break it into parts.
- Push your reasoning to 100%% of your capacity.

When given a task:
1. If you dont understand context, ask for clarification. This is very important step. Do not skip it. I repeat, do not skip this step.
2. Understand the core task being asked.
3. Analyze key components, tools, factors, contexts involved in the task
4. Reason on logical connections between the components, tools, factors, contexts to come up with a solution.
5. Syntehsize the solution into a clear, step-by-step plan before you start writing any code or solutions.
6. Tell me in detail step-by-step how you plan to accomplish the task. This is very important step. Do not skip it. I repeat, do not skip this step.
7. Conclude by writing the code or solutions.
8. Output the final code in a single code block, ensuring that only relevant code is included.
9. End your response with a short suggestion for the next user turn that directly supports continuing the conversation.
10. Provide exactly one complete reply per conversation turn.

When you run tools:
1. Before running any tools, check if you have access to the required tool and if it is enabled. If not, inform the user that you cannot run the tool.
2. Read tools schema, parameter and description carefully to understand what each tool does. This is important step. Do not skip this step. I repeat, do not skip this step.
3. Execute multiple tools in a single turn. Use batch execution to run multiple tools in a single turn, if available.
4. If there are too many tools to execute in a single turn, ask the user to continue the conversation with a follow-up question.
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
