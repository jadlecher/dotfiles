return {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v3.x',
  dependencies = {
    { 'folke/neodev.nvim' },
    { 'lukas-reineke/lsp-format.nvim' },
    { 'neovim/nvim-lspconfig' },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-path' },
    {
      'L3MON4D3/LuaSnip',
      build = "make install_jsregexp",
    },
    { 'saadparwaiz1/cmp_luasnip' },
  },
  config = function()
    local lsp_zero = require('lsp-zero')
    local lsp_format = require('lsp-format')
    lsp_format.setup({})
    lsp_zero.on_attach(function(_, bufnr)
      lsp_zero.default_keymaps({ buffer = bufnr })
    end)

    require('neodev').setup({}) -- configure lua_ls settings for neovim plugin development
    require('mason').setup({})
    require('mason-lspconfig').setup({
      ensure_installed = {
        -- c++
        'clangd',
        'cmake',
        -- web development
        'jsonls',
        'eslint',
        -- scripting
        'pyright',
        'lua_ls',
        -- system administration
        'ansiblels',
        'terraformls',
      },
      handlers = {
        lsp_zero.default_setup,
      }
    })

    local cmp = require('cmp')
    local cmp_format = lsp_zero.cmp_format()
    cmp.setup({
      sources = {
        { name = 'nvim_lua' },
        {
          name = 'nvim_lsp',
          entry_filter = function(entry, _)
            -- disable lsp TEXT completion results
            return entry:get_kind() ~= require("cmp").lsp.CompletionItemKind.Text
          end
        },
        { name = 'luasnip' },
        { name = 'path' },
      },
      --- (Optional) Show source name in completion menu
      formatting = cmp_format,
    })
  end
}
