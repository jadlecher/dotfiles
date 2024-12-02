return {
	"catppuccin/nvim",
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
			background = {
				light = "latte",
				dark = "mocha",
			},
		})
		vim.cmd.colorscheme("catppuccin")
		require("utils.background-switcher").switch()
		vim.api.nvim_create_autocmd("Signal", {
			pattern = { "SIGUSR1" },
			callback = function()
				require("utils.background-switcher").switch()
			end,
		})
	end,
}
