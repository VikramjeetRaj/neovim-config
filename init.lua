-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Core editor config (options must load before plugins so e.g. netrw is
-- disabled before nvim-tree, and folding uses treesitter once available).
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Plugins: every file under lua/plugins/ returns a lazy.nvim spec.
require("lazy").setup({
	{ import = "plugins" },
})
