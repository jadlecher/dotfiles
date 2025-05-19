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
	opts = {},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"echasnovski/mini.diff",
		"j-hui/fidget.nvim",
	},
	config = function()
		require("codecompanion").setup({
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

			adapters = {
				gemini = function()
					local choices = require("codecompanion.adapters.gemini").schema.model.choices
					choices = vim.list_extend(
						vim.deepcopy(choices),
						{ "gemini-2.5-flash-preview-04-17", "gemini-2.5-pro-preview-03-25" }
					)
					return require("codecompanion.adapters").extend("gemini", {
						schema = {
							model = {
								default = "gemini-2.5-flash-preview-04-17",
								choices = choices,
							},
						},
					})
				end,
			},
			strategies = {
				chat = { adapter = "gemini" },
				inline = { adapter = "gemini" },
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
		})
	end,
	init = function()
		require("plugins.codecompanion.fidget-spinner"):init()
	end,
}
