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
				return require("codecompanion.adapters").extend("gemini", {})
			end,
			anthropic = function()
				return require("codecompanion.adapters").extend("anthropic", {})
			end,
		},
		strategies = {
			chat = { adapter = "gemini" },
			inline = { adapter = "gemini" },
		},
		opts = {
			system_prompt = function(_)
				local prompt_file = vim.fn.stdpath("config") .. "/lua/plugins/codecompanion/system_prompt.md"
				local prompt_content = read_file(prompt_file)
				if prompt_content then
					return prompt_content
				else
					print("Error reading system prompt file: " .. prompt_file)
					return ""
				end
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
