-- ~/.config/nvim/init.lua

-- Set some basic options
vim.opt.nu = true -- Enable line numbers
vim.opt.relativenumber = true -- Enable relative line numbers (super useful for jumping!)
vim.opt.tabstop = 4 -- Number of spaces a tab counts for
vim.opt.shiftwidth = 4 -- Number of spaces to use for each step of indentation
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.smartindent = true -- Smartly indent a new line
vim.opt.hlsearch = false -- Don't highlight search results by default

-- A basic keymap to save the file
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
