pcall(vim.cmd, "GitBlameDisable")
-- git blame 
vim.keymap.set("n", "<leader>gb", "<cmd>GitBlameToggle<CR>")
