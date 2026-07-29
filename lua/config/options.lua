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
vim.opt.relativenumber = false

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
vim.opt.expandtab = true -- Tab inserts spaces, never a real tab character
vim.opt.tabstop = 8 -- a tab is displayed as 8 spaces
vim.opt.shiftwidth = 8 -- >> / << and auto-indent use 8 spaces
vim.opt.softtabstop = 8 -- Tab / Backspace move by a full 8-space step (JetBrains-like)
vim.opt.autoindent = true -- keep the current line's indent on the next line (Enter)
vim.opt.smartindent = true -- add an extra indent level after `{`, etc.

-- Autosave (JetBrains-style): save on insert-leave, text change, buffer/focus loss
vim.opt.updatetime = 1000
