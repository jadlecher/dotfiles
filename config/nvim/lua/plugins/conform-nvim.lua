return {
	"stevearc/conform.nvim",
	dependencies = {
		"williamboman/mason.nvim",
		"zapling/mason-conform.nvim",
	},
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			sh = { "shfmt" },
			lua = { "stylua" },
			python = { "isort", "black" },
			html = { "prettierd" },
			javascript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescript = { "prettierd" },
			typescriptreact = { "prettierd" },
			css = { "prettierd" },
			toml = { "taplo" },
			yaml = { "prettierd" },
			text = { "latexindent" },
			-- cxx
			cmake = { "cmake_format" },
		},
		format_on_save = { timeout_ms = 2000, lsp_fallback = true },
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
	config = function(_, opts)
		require("mason-conform").setup({})
		local conform = require("conform")
		conform.setup(opts)
	end,
}
