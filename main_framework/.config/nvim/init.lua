-- ~/.config/nvim/init.lua

-- LazyVim setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "tiagovla/tokyodark.nvim", -- Theme
  "nvim-tree/nvim-tree.lua", -- File explorer
  "nvim-treesitter/nvim-treesitter", -- Better syntax highlighting
  -- "nvim-cmp", -- Autocompletion with LSP support
  'hrsh7th/nvim-cmp',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    -- Snippet engine (choose one)
    {'hrsh7th/cmp-vsnip', 'hrsh7th/vim-vsnip'},
    -- Or
    -- {'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip'},
  },
  -- "nvim-lspconfig", -- Common LSP configs
  -- "telescope.nvim", -- Fuzzy Finder
  'nvim-telescope/telescope.nvim', tag = '0.1.9',
  dependencies = { 'nvim-lua/plenary.nvim' },
  -- "gitsigns.nvim", -- Show Git status metadata
})

vim.lsp.enable('ccls')

-- Set some basic options
vim.opt.nu = true -- Enable line numbers
vim.opt.relativenumber = false -- Enable relative line numbers (super useful for jumping!)
vim.opt.tabstop = 4 -- Number of spaces a tab counts for
vim.opt.shiftwidth = 4 -- Number of spaces to use for each step of indentation
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.smartindent = true -- Smartly indent a new line
vim.opt.hlsearch = false -- Don't highlight search results by default

-- OSC 52 clipboard: syncs yank/paste with the system clipboard over SSH,
-- without needing a Wayland/X11 display server. Uses Neovim's built-in
-- provider (0.10+) rather than a plugin, since nvim-osc52 is now obsolete
-- per its own README (see :h clipboard-osc52 for details)
-- Only force OSC 52 when connected over SSH; locally, let Neovim's
-- normal auto-detection find wl-copy/wl-paste via a running Wayland
-- session instead, which is more reliable than OSC 52 when available
if vim.env.SSH_TTY then
  vim.g.clipboard = "osc52"
end

-- Routes plain y/d/p through the "+" register automatically, so OSC 52
-- fires on every yank/paste without needing "+y / "+p explicitly
vim.opt.clipboard = "unnamedplus"


-- A basic keymap to save the file
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })

-- Telescope keymaps
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
