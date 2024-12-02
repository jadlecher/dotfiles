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
            cmake_executable = require('utils.find-cmake-executable').find()
            if cmake_executable ~= nil then
              return cmake_executable
            else
              return vim.fn.input('Path to executable: ',
                vim.fn.getcwd() .. '/build', 'file')
            end
          end,
          cwd = "${workspaceFoldler}",
        }
      }
    end,
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', "nvim-neotest/nvim-nio" },
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
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
      require("nvim-dap-virtual-text").setup()
    end
  },
}
