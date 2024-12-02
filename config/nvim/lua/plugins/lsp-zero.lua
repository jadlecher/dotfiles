return {
	"VonHeikemen/lsp-zero.nvim",
	branch = "v4.x",
	dependencies = {
		{ "folke/neodev.nvim" },
		{ "lukas-reineke/lsp-format.nvim" },
		{ "neovim/nvim-lspconfig" },
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },
		{ "hrsh7th/nvim-cmp" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/cmp-path" },
		{ "hrsh7th/cmp-buffer" },
		{
			"L3MON4D3/LuaSnip",
			build = "make install_jsregexp",
		},
		{ "saadparwaiz1/cmp_luasnip" },
	},
	config = function()
		local lsp_zero = require("lsp-zero")
		local lsp_format = require("lsp-format")
		lsp_format.setup({})
		local lsp_attach = function(_, bufnr)
			lsp_zero.default_keymaps({ buffer = bufnr })
		end
		lsp_zero.extend_lspconfig({
			capabilities = require("cmp_nvim_lsp").default_capabilities(),
			lsp_attach = lsp_attach,
			float_border = "rounded",
			sign_text = true,
		})

		require("neodev").setup({}) -- configure lua_ls settings for neovim plugin development
		require("mason").setup({})
		require("mason-lspconfig").setup({
			ensure_installed = {
				-- c++
				"clangd",
				"cmake",
				-- web development
				"jsonls",
				"eslint",
				-- scripting
				"pyright",
				"lua_ls",
				-- system administration
				"ansiblels",
				"terraformls",
				-- misc
				"texlab",
			},
			handlers = {
				lsp_zero.default_setup,
				clangd = function()
					require("lspconfig").clangd.setup({
						init_options = {
							compilationDatabasePath = "./build",
						},
					})
				end,
				eslint = function()
					require("lspconfig").eslint.setup({
						on_attach = function(_, bufnr)
							vim.api.nvim_create_autocmd("BufWritePre", {
								buffer = bufnr,
								command = "EslintFixAll",
							})
						end,
					})
				end,
			},
			texlab = function()
				require("lspconfig").texlab.setup({
					auxDirectory = "./build",
				})
			end,
		})

		local cmp = require("cmp")
		local cmp_format = lsp_zero.cmp_format({})
		cmp.setup({
			sources = {
				{ name = "nvim_lua" },
				{
					name = "nvim_lsp",
					entry_filter = function(entry, _)
						-- disable lsp TEXT completion results
						return entry:get_kind() ~= require("cmp").lsp.CompletionItemKind.Text
					end,
				},
				{ name = "buffer" },
				{ name = "luasnip" },
				{ name = "path" },
			},
			--- (Optional) Show source name in completion menu
			formatting = cmp_format,
			mapping = cmp.mapping.preset.insert({}),
		})
	end,
}
