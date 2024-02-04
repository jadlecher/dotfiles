-- nvim-dap bindings
local dap = require('dap')
local dapui = require('dapui')
vim.keymap.set("n", "<leader>bb", function() dap.repl.toggle({ height = 10 }) end)
vim.keymap.set("n", "<leader>bu", dapui.toggle)
vim.keymap.set("n", "<leader>bp", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader>bx", dap.clear_breakpoints)
vim.keymap.set("n", "<leader>bn", dap.continue)
vim.keymap.set("n", "<leader>bq", dap.terminate)
vim.keymap.set("n", "<leader>br", dap.restart)
vim.keymap.set("n", "<leader>bl", dap.step_over)
vim.keymap.set("n", "<leader>bj", dap.step_into)
vim.keymap.set("n", "<leader>bk", dap.step_out)
vim.keymap.set("n", "<leader>bh", dap.step_back)
vim.keymap.set("n", "<leader>b.", dap.run_last)

vim.keymap.set("n", "<leader>rr", function()
  executable = require('utils.find-cmake-executable').find()
  if executable ~= nil then vim.fn.system(executable) end
end)

vim.keymap.set("n", "<leader>qf", "<cmd>lua vim.lsp.buf.code_action()<cr>")

vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<cr>")

vim.api.nvim_create_user_command('Redir', function(ctx)
  local lines = vim.split(vim.api.nvim_exec(ctx.args, true), '\n', { plain = true })
  vim.cmd('enew')
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.opt_local.modified = false
end, { nargs = '+', complete = 'command' })
