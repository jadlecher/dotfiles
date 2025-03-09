-- nvim-dap bindings
vim.keymap.set("n", "<leader>rr", function()
	local executable = require("utils.find-cmake-executable").find()
	if executable ~= nil then
		vim.fn.system(executable)
	end
end)

vim.keymap.set("n", "<leader>qf", "<cmd>lua vim.lsp.buf.code_action()<cr>")
vim.keymap.set("n", "<leader>r", "<cmd>LspRestart<cr>")

vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<cr>")
