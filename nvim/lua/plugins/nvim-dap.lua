return {
  {
    'mfussenegger/nvim-dap',
    config = function()
      local dap = require('dap')

      -- c / c++
      dap.adapters.gdb = {
        type = 'executable',
        command = 'gdb',
        args = { '-i', 'dap' }
      }
      dap.configurations.cpp = {
        {
          name = 'Launch',
          type = 'gdb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ',
              vim.fn.getcwd() .. '/build', 'file')
          end,
          cwd = "${workspaceFoldler}",
        }
      }
    end,
  },
  {
    'theHamsta/nvim-dap-ui',
    config = function()
      require("dapui").setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 1.0 },
            },
            position = "bottom",
            size = 10,
          },
        }
      })
    end
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    config = function()
      require("nvim-dap-virtual-text").setup()
    end
  },
}
