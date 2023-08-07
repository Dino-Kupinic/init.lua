-- TODO:
-- FIX:
-- HACK:
-- WARN:
-- PERF:
-- NOTE:
-- TEST:

require("todo-comments").setup {
  keywords = {
    HACK = {
      color = "#9312ab",
    },
    PERF = {
      color = "#ffffff",
    },
    NOTE = {
      color = "#10b880",
    },
  }
}

vim.keymap.set("n", "<leader>td", "<cmd>TodoTelescope initial_mode=normal<CR>")
