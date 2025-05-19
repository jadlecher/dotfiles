return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			auto_install = true,
			ensure_installed = {
				"bash",
				"c",
				"cpp",
				"lua",
				"python",
				"regex",
				"yaml",
				"markdown",
				"markdown_inline",
			},
			highlight = { enable = true },
			indent = { enable = true },
			autotag = { enable = true },
			sync_install = false,
			ignore_install = {},
			modules = {},
		})
	end,
}
