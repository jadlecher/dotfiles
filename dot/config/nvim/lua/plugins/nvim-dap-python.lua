return {
  'mfussenegger/nvim-dap-python',
  dependencies = { 'mfussenegger/nvim-dap' },
  enabled = true,
  config = function()
    local status, dap = pcall(require, 'dap')
    if not status then
      return
    end
    local dappython
    status, dappython = pcall(require, 'dap-python')
    if not status then
      return
    end
    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        justMyCode = false,
      },
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file with arguments',
        program = '${file}',
        justMyCode = false,
        args = function()
          local args_string = vim.fn.input('Arguments: ')
          return vim.split(args_string, ' +')
        end,
      },
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file (console = integratedTerminal)',
        program = '${file}',
        console = 'integratedTerminal',
        justMyCode = false,
      },
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file with arguments (console = integratedTerminal)',
        program = '${file}',
        console = 'integratedTerminal',
        justMyCode = false,
        args = function()
          local args_string = vim.fn.input('Arguments: ')
          return vim.split(args_string, ' +')
        end,
      },
    }
    local venv = vim.fn.expand('~/.venv/bin/python')

    if vim.fn.filereadable(venv) == 0 then
      vim.schedule(function()
        vim.api.nvim_notify('no python venv detected at ' .. venv, vim.log.levels.WARN, {})
      end)
    end
    dappython.setup('~/.venv/bin/python', {
      include_configs = true,
      console = 'integratedTerminal',
      pythonPath = nil,
    })
  end,
}
