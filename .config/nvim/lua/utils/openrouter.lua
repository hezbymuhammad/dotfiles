local log = require("codecompanion.utils.log")
local utils = require("codecompanion.utils.adapters")
local openai = require("codecompanion.adapters.http.openai")

local MODEL_CHOICES = {
	["openai/gpt-5-mini"] = {
		opts = {
			can_reason = true,
			has_vision = false,
			params = {},
		},
	},
	["openai/gpt-5"] = {
		opts = {
			can_reason = true,
			reasoning_effort = "high",
			has_vision = false,
			params = {},
		},
	},
	["openai/gpt-oss-120b"] = {
		opts = {
			can_reason = true,
			reasoning_effort = "high",
			has_vision = false,
			params = {
				frequency_penalty = -0.1,
				presence_penalty = -0.1,
				temperature = 0.8,
			},
		},
	},
	["moonshotai/kimi-k2"] = {
		opts = {
			can_reason = false,
			has_vision = false,
			params = {
				frequency_penalty = -0.1,
				top_p = 0.7,
			},
		},
	},
	["z-ai/glm-4.5"] = {
		opts = {
			can_reason = true,
			has_vision = false,
			params = {
				frequency_penalty = -0.1,
				top_p = 0.7,
			},
		},
	},
	["anthropic/claude-sonnet-4"] = {
		opts = {
			can_reason = true,
			has_vision = false,
			params = {
				temperature = 0.8,
			},
		},
	},
	["google/gemini-2.5-flash"] = {
		opts = {
			can_reason = true,
			has_vision = false,
			params = {
				temperature = 0.8,
			},
		},
	},
	["google/gemini-2.5-pro"] = {
		opts = {
			can_reason = true,
			has_vision = false,
			params = {
				temperature = 0.8,
			},
		},
	},
}
local ALLOWED_MESSAGE_FIELDS = { "content", "role", "tool_calls", "tool_call_id" }

local function shallow_copy(tbl)
	if type(tbl) ~= "table" then
		return tbl
	end
	local out = {}
	for k, v in pairs(tbl) do
		out[k] = v
	end
	return out
end

local function get_model(self)
	local model = self.schema.model.default
	if type(model) == "function" then
		model = model(self)
	end
	return model
end

local function get_model_choices(self)
	local choices = self.schema.model.choices
	if type(choices) == "function" then
		choices = choices(self)
	end
	return choices or {}
end

local function get_model_opts(self)
	local choices = get_model_choices(self)
	local model = get_model(self)
	local entry = choices[model]
	return (entry and entry.opts) and entry.opts or {}
end

local function sanitize_message(msg)
	local sanitized = {}
	for _, key in ipairs(ALLOWED_MESSAGE_FIELDS) do
		if msg[key] ~= nil then
			sanitized[key] = msg[key]
		end
	end
	return sanitized
end

local function map_tool_calls(tool_calls)
	if not tool_calls then
		return nil
	end
	local out = {}
	for _, tool_call in ipairs(tool_calls) do
		table.insert(out, {
			id = tool_call.id,
			["function"] = tool_call["function"],
			type = tool_call.type,
		})
	end
	return out
end

return {
	name = "openrouter",
	formatted_name = "Open Router",
	roles = {
		llm = "assistant",
		user = "user",
		tool = "tool",
	},
	opts = {
		stream = true,
		tools = true,
		vision = true,
	},
	features = {
		text = true,
		tokens = true,
	},
	url = "${url}${chat_url}",
	env = {
		api_key = "OPENAI_API_KEY",
		url = "https://openrouter.ai/api",
		chat_url = "/v1/chat/completions",
		models_endpoint = "/v1/models",
	},
	headers = {
		["Content-Type"] = "application/json",
		Authorization = "Bearer ${api_key}",
	},
	body = {
		provider = {
			require_parameters = true,
		},
	},
	temp = {},
	handlers = {
		setup = function(self)
			local model_opts = get_model_opts(self)

			self.opts.vision = true
			if model_opts and model_opts.has_vision == false then
				self.opts.vision = false
			end

			if self.opts and self.opts.stream then
				self.parameters.stream = true
				self.parameters.stream_options = { include_usage = true }
			end

			return true
		end,

		form_parameters = function(self, params, _)
			if self.temp.reasoning_effort then
				params.reasoning = {
					max_tokens = self.temp.reasoning_max_tokens,
				}
			end
			return params
		end,

		form_messages = function(self, messages)
			local model = get_model(self)
			local out = {}

			for _, m in ipairs(messages) do
				local msg = shallow_copy(m)
				local skip = false

				if vim.startswith(model, "o1") and msg.role == "system" then
					msg.role = self.roles.user
				end

				if msg.tool_calls then
					msg.tool_calls = map_tool_calls(msg.tool_calls)
				end

				if msg.opts and msg.opts.tag == "image" and msg.opts.mimetype then
					if self.opts and self.opts.vision then
						msg.content = {
							{
								type = "image_url",
								image_url = { url = string.format("data:%s;base64,%s", msg.opts.mimetype, msg.content) },
							},
						}
					else
						skip = true
					end
				end

				if not skip then
					if msg.reasoning and msg.reasoning.content then
						local reasoning_msg = sanitize_message({
							role = self.roles.user,
							content = "### please consider the following reasonig when answering:\n"
								.. msg.reasoning.content,
						})
						table.insert(out, reasoning_msg)
					end

					msg = sanitize_message(msg)
					table.insert(out, msg)
				end
			end

			return { messages = out }
		end,

		form_reasoning = function(_, data)
			local content = vim.iter(data)
				:map(function(item)
					return item.content
				end)
				:filter(function(c)
					return c ~= nil
				end)
				:join("")

			return { content = content }
		end,

		form_tools = function(self, tools)
			if not self.opts.tools or not tools then
				return
			end
			if vim.tbl_count(tools) == 0 then
				return
			end

			local transformed = {}
			for _, tool in pairs(tools) do
				for _, schema in pairs(tool) do
					table.insert(transformed, schema)
				end
			end

			return { tools = transformed }
		end,

		tokens = function(_, data)
			if data and data ~= "" then
				local data_mod = utils.clean_streamed_data(data)
				local ok, json = pcall(vim.json.decode, data_mod, { luanil = { object = true } })
				if ok and json.usage then
					local tokens = json.usage.total_tokens
					log:trace("Tokens: %s", tokens)
					return tokens
				end
			end
		end,

		chat_output = function(self, data, tools)
			local output = {}

			if not data or data == "" then
				return nil
			end

			local data_mod = type(data) == "table" and data.body or utils.clean_streamed_data(data)
			local ok, json = pcall(vim.json.decode, data_mod, { luanil = { object = true } })
			if not ok or not json.choices or #json.choices == 0 then
				return nil
			end

			if self.opts.tools and tools then
				for _, choice in ipairs(json.choices) do
					local delta = self.opts.stream and choice.delta or choice.message
					if delta and delta.tool_calls and #delta.tool_calls > 0 then
						for i, tool in ipairs(delta.tool_calls) do
							local tool_index = tool.index and tonumber(tool.index) or i

							local id = tool.id
							if not id or id == "" then
								id = string.format("call_%s_%s", json.created, i)
							end

							if self.opts.stream then
								local found = false
								for _, existing_tool in ipairs(tools) do
									if existing_tool._index == tool_index then
										if tool["function"] and tool["function"].arguments then
											existing_tool["function"].arguments = (
												existing_tool["function"].arguments or ""
											) .. tool["function"].arguments
										end
										found = true
										break
									end
								end

								if not found then
									table.insert(tools, {
										_index = tool_index,
										id = id,
										type = tool.type,
										["function"] = tool["function"] and {
											name = tool["function"].name,
											arguments = tool["function"].arguments or "",
										} or nil,
									})
								end
							else
								table.insert(tools, {
									_index = i,
									id = id,
									type = tool.type,
									["function"] = tool["function"] and {
										name = tool["function"].name,
										arguments = tool["function"].arguments,
									} or nil,
								})
							end
						end
					end
				end
			end

			local choice = json.choices[1]
			local delta = self.opts.stream and choice.delta or choice.message
			if not delta then
				return nil
			end

			local can_reason = false
			if self.temp.reasoning_effort then
				can_reason = true
			end

			if can_reason and delta.reasoning then
				output.reasoning = output.reasoning or {}
				output.reasoning.content = (output.reasoning.content or "") .. delta.reasoning
				output.role = delta.role
				return { status = "success", output = output }
			end

			if delta.content then
				output.role = delta.role
				output.content = delta.content
				return { status = "success", output = output }
			end

			return nil
		end,

		inline_output = function(self, data)
			return openai.handlers.inline_output(self, data)
		end,

		tools = {
			format_tool_calls = function(self, t)
				return openai.handlers.tools.format_tool_calls(self, t)
			end,

			output_response = function(self, tool_call, output)
				return openai.handlers.tools.output_response(self, tool_call, output)
			end,
		},

		on_exit = function(_, data)
			if data and data.status >= 400 then
				log:error("Error: %s", data.body)
			end
		end,
	},

	schema = {
		model = {
			order = 1,
			mapping = "parameters",
			type = "enum",
			desc = "ID of the model to use. See the model endpoint compatibility table for details on which models work with the Chat API.",
			default = next(MODEL_CHOICES),
			choices = MODEL_CHOICES,
		},

		reasoning_effort = {
			order = 2,
			mapping = "temp",
			type = "string",
			optional = true,
			condition = function(self)
				local opts = get_model_opts(self)
				return opts.can_reason == true
			end,
			default = function(self)
				local opts = get_model_opts(self)
				return opts.reasoning_effort or "medium"
			end,
			desc = "Constrains effort on reasoning for reasoning models. Reducing reasoning effort can result in faster responses and fewer tokens used on reasoning in a response.",
			choices = { "high", "medium", "low" },
		},

		reasoning_max_tokens = {
			order = 3,
			mapping = "temp",
			type = "number",
			optional = true,
			condition = function(self)
				local opts = get_model_opts(self)
				return opts.can_reason == true
			end,
			default = 10000,
			desc = "Max tokens for reasoning",
		},

		temperature = {
			order = 4,
			mapping = "parameters",
			type = "number",
			optional = true,
			condition = function(self)
				local opts = get_model_opts(self)
				return opts and opts.params and opts.params.temperature ~= nil
			end,
			default = function(self)
				local opts = get_model_opts(self)
				return opts.params.temperature
			end,
			desc = "What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or top_p but not both.",
			validate = function(n)
				return n >= 0 and n <= 2, "Must be between 0 and 2"
			end,
		},

		top_p = {
			order = 5,
			mapping = "parameters",
			type = "number",
			optional = true,
			condition = function(self)
				local opts = get_model_opts(self)
				return opts and opts.params and opts.params.top_p ~= nil
			end,
			default = function(self)
				local opts = get_model_opts(self)
				return opts.params.top_p
			end,
			desc = "An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered. We generally recommend altering this or temperature but not both.",
			validate = function(n)
				return n >= 0 and n <= 1, "Must be between 0 and 1"
			end,
		},

		stop = {
			order = 6,
			mapping = "parameters",
			type = "list",
			optional = true,
			condition = function(self)
				local opts = get_model_opts(self)
				return opts and opts.params and opts.params.stop ~= nil
			end,
			default = function(self)
				local opts = get_model_opts(self)
				return opts.params.stop
			end,
			subtype = { type = "string" },
			desc = "Up to 4 sequences where the API will stop generating further tokens.",
			validate = function(l)
				return #l >= 1 and #l <= 4, "Must have between 1 and 4 elements"
			end,
		},

		max_tokens = {
			order = 7,
			mapping = "parameters",
			type = "integer",
			optional = true,
			default = 50000,
			desc = "The maximum number of tokens to generate in the chat completion. The total length of input tokens and generated tokens is limited by the model's context length.",
			validate = function(n)
				return n > 0, "Must be greater than 0"
			end,
		},

		presence_penalty = {
			order = 8,
			mapping = "parameters",
			type = "number",
			optional = true,
			condition = function(self)
				local opts = get_model_opts(self)
				return opts and opts.params and opts.params.presence_penalty ~= nil
			end,
			default = function(self)
				local opts = get_model_opts(self)
				return opts.params.presence_penalty
			end,
			desc = "Float that penalizes new tokens based on whether they appear in the generated text so far. Values > 0 encourage the model to use new tokens, while values < 0 encourage the model to repeat tokens",
			validate = function(n)
				return n >= -2 and n <= 2, "Must be between -2 and 2"
			end,
		},

		frequency_penalty = {
			order = 9,
			mapping = "parameters",
			type = "number",
			optional = true,
			condition = function(self)
				local opts = get_model_opts(self)
				return opts and opts.params and opts.params.frequency_penalty ~= nil
			end,
			default = function(self)
				local opts = get_model_opts(self)
				return opts.params.frequency_penalty
			end,
			desc = "Float that penalizes new tokens based on their frequency in the generated text so far. Values > 0 encourage the model to use new tokens, while values < 0 encourage the model to repeat tokens",
			validate = function(n)
				return n >= -2 and n <= 2, "Must be between -2 and 2"
			end,
		},
	},
}
