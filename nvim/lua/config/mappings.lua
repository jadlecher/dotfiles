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

vim.keymap.set("n", "<leader>qf", "<cmd>lua vim.lsp.buf.code_action()<cr>")

vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<cr>")
