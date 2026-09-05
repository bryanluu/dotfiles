-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- ============================================================
-- Comment toggle: free Ctrl+/ (and its <C-_> terminal-encoded
-- twin) from LazyVim's default terminal toggle, repurpose for
-- comments instead
-- ============================================================
vim.keymap.del("n", "<C-/>")
vim.keymap.del("n", "<C-_>")

vim.keymap.set("n", "<C-/>", "gcc", { desc = "Toggle comment", remap = true })
vim.keymap.set("n", "<C-_>", "gcc", { desc = "Toggle comment", remap = true })
vim.keymap.set("v", "<C-/>", "gc", { desc = "Toggle comment (selection)", remap = true })
vim.keymap.set("v", "<C-_>", "gc", { desc = "Toggle comment (selection)", remap = true })
