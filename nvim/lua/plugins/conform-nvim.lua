return {
	"stevearc/conform.nvim",
	dependencies = { "WhoIsSethDaniel/mason-tool-installer.nvim" },
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
			lua = { "stylua" },
			python = { "isort", "black" },
			javascript = { { "prettierd" } },
		},
		format_on_save = { timeout_ms = 500, lsp_fallback = true },
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
	config = function(_, opts)
		local conform = require("conform")
		conform.setup(opts)
		local required_formatters = vim.fn.map(conform.list_all_formatters(), function(_, formatter)
			return formatter.name
		end)
		local installer = require("mason-tool-installer")
		installer.setup({
			ensure_installed = required_formatters,
		})
		vim.api.nvim_command("MasonToolsInstall")
	end,
}
