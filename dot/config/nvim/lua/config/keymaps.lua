local map = vim.keymap.set

-- CodeCompanion keymaps
map("n", "<leader>aa", "<cmd>CodeCompanionActions<CR>", { desc = "CodeCompanion Actions" })
map("n", "<leader>ac", "<cmd>CodeCompanionChat<CR>", { desc = "CodeCompanion Chat" })
map("n", "<leader>ah", "<cmd>CodeCompanionHistory<CR>", { desc = "CodeCompanion History: Open" })

map("v", "<leader>ac", ":<C-u>CodeCompanionChat Add<CR>", { desc = "CodeCompanion Chat: Add Selection" })

vim.cmd([[cab cc CodeCompanion]]) -- expand 'cc' into 'CodeCompanion' in the command line
