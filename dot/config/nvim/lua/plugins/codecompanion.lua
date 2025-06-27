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
		"echasnovski/mini.diff",
		-- extensions
		"ravitemer/codecompanion-history.nvim",
	},
	opts = {
		adapters = {
			opts = {
				show_defaults = false,
				show_model_choices = true,
			},
			gemini = function()
				local choices = require("codecompanion.adapters.gemini").schema.model.choices
				choices = vim.list_extend(vim.deepcopy(choices), { "gemini-2.5-flash", "gemini-2.5-pro" })
				return require("codecompanion.adapters").extend("gemini", {
					schema = {
						model = {
							default = "gemini-2.5-pro",
							choices = choices,
						},
					},
				})
			end,
			anthropic = function()
				return require("codecompanion.adapters").extend("anthropic", {})
			end,
		},
		strategies = {
			chat = {
				adapter = "gemini",
				-- override default binding for options (?) to preserve reverse search
				keymaps = {
					options = {
						modes = {
							n = "gh",
						},
						callback = "keymaps.options",
						description = "Options",
						hide = true,
					},
				},
			},
			inline = { adapter = "gemini" },
		},
		opts = {
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
	config = function(_, opts)
		require("codecompanion").setup(opts)
	end,
}
