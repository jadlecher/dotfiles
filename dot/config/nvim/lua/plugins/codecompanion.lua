local function read_file(filepath)
	local file = io.open(filepath, "r")
	if not file then
		return nil
	end
	local content = file:read("*a")
	file:close()
	return content
end

return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-mini/mini.diff",
		-- extensions
		{ "ravitemer/codecompanion-history.nvim" },
	},

	opts = {
		adapters = {
			http = {
				opts = {
					show_presets = false,
					show_model_choices = true,
				},

				gemini = function()
					return require("codecompanion.adapters").extend("gemini", {})
				end,
				anthropic = function()
					return require("codecompanion.adapters").extend("anthropic", {})
				end,
				openai = function()
					return require("codecompanion.adapters").extend("openai", {})
				end,
			},

			acp = {
				opts = {
					show_presets = false,
				},

				claude_code = function()
					return require("codecompanion.adapters").extend("claude_code", {})
				end,
			},
		},

		display = {
			chat = {
				window = {
					layout = "buffer",
				},
			},
			diff = {
				provider = "mini_diff",
			},
		},

		interactions = {
			chat = {
				adapter = { name = "openai", model = "gpt-5" },
				-- override default binding for options (?) to preserve reverse search
				keymaps = {
					options = {
						modes = {
							n = "gH",
						},
						callback = "keymaps.options",
						description = "Options",
						hide = true,
					},
				},
			},
			inline = {
				adapter = { name = "openai", model = "gpt-5" },
				keymaps = {
					accept_change = {
						modes = { n = "ga" },
						description = "Accept the suggested change",
					},
					reject_change = {
						modes = { n = "gr" },
						opts = { nowait = true },
						description = "Reject the suggested change",
					},
				},
			},

			system_prompt = function(opts)
				local prompts_dir = vim.fn.stdpath("config") .. "/lua/plugins/codecompanion/prompts"
				local adapter_name = opts.adapter and opts.adapter.name

				-- Try adapter-specific prompt first
				local prompt_content = nil
				if adapter_name then
					local prompt_file = prompts_dir .. "/" .. adapter_name .. "/system.md"
					prompt_content = read_file(prompt_file)
				end

				-- Fallback to default prompt
				if prompt_content == nil or prompt_content == "" then
					local prompt_file = prompts_dir .. "/system.md"
					prompt_content = read_file(prompt_file)
				end

				-- If neither is found, print an error and return an empty string
				if prompt_content == nil or prompt_content == "" then
					print("CodeCompanion: No system prompt found. Looked for adapter-specific and default prompts.")
					return ""
				end
				return prompt_content
			end,
		},

		extensions = {
			history = {
				enabled = true,
				opts = {
					keymap = "gh",
					auto_save = true,
					expiration_days = 0, -- 0 = disabled
					picker = "default",
					continue_last_chat = false,
					dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
				},
			},
		},
	},
}
