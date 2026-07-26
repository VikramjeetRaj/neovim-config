-- Editor options and global settings

-- Recommended: disable netrw when using nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true
vim.opt.timeoutlen = 1500

-- Disable mouse entirely
vim.opt.mouse = ""

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99 -- start with everything expanded

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Line Number
vim.opt.number = true
vim.opt.relativenumber = true

-- Core editor settings
vim.opt.signcolumn = "yes" -- avoid layout shift from git/diagnostic signs
vim.opt.scrolloff = 8 -- keep cursor away from screen edges
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.ignorecase = true
vim.opt.smartcase = true -- case-sensitive only when the query has a capital
vim.opt.undofile = true -- persistent undo across sessions
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true

-- Autosave (JetBrains-style): save on insert-leave, text change, buffer/focus loss
vim.opt.updatetime = 1000
