-- Line numbers
vim.opt.number = true              -- show absolute line numbers
vim.opt.relativenumber = true      -- also show relative numbers (handy for counted motions, e.g. 5dd)

-- Indentation
vim.opt.shiftwidth = 4             -- width of one indent level
vim.opt.tabstop = 4                -- width a <Tab> character displays as
vim.opt.expandtab = true           -- insert spaces instead of tab characters

-- Search
vim.opt.incsearch = true           -- highlight matches as you type
vim.opt.ignorecase = true          -- case-insensitive search...
vim.opt.smartcase = true           -- ...unless the search includes a capital letter
vim.opt.hlsearch = true            -- highlight all matches after searching

-- Editing feel
vim.opt.scrolloff = 10             -- keep 10 lines visible above/below the cursor
vim.opt.wrap = false                -- don't wrap long lines
vim.opt.mouse = "a"                -- enable mouse support in all modes
vim.opt.backup = false             -- don't leave stray backup files around

-- Status and feedback
vim.opt.showcmd = true             -- show partial commands in the bottom right
vim.opt.showmode = true            -- show current mode (INSERT, VISUAL, etc.)
vim.opt.showmatch = true           -- briefly jump to the matching bracket/paren

-- History and persistent undo
vim.opt.history = 1000             -- remember more command-line history
local undodir = vim.fn.stdpath("data") .. "/undodir"
vim.fn.mkdir(undodir, "p")         -- create the undo directory if it doesn't exist yet
vim.opt.undofile = true            -- keep undo history even after closing a file
vim.opt.undodir = undodir

-- Clipboard: share yanks/deletes with the macOS system clipboard
vim.opt.clipboard = "unnamed"

-- Splits and colors
vim.opt.termguicolors = true       -- enable full 24-bit color support
vim.opt.splitright = true          -- vertical splits open to the right
vim.opt.splitbelow = true          -- horizontal splits open below

-- Leader key, used for any custom shortcuts you add later
vim.g.mapleader = " "
