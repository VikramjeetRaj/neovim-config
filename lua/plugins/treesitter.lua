return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "json", "jsonc", "lua", "go", "vim", "vimdoc", "cpp", "c", "java" },
			highlight = { enable = true },
			-- Treesitter indent is experimental and sets `indentexpr`, which
			-- overrides autoindent/smartindent and often fails to carry indent
			-- onto the next line on Enter. Disabled so Neovim's reliable built-in
			-- indenters (e.g. C/C++ cindent) handle indentation instead.
			indent = { enable = false },
		})
	end,
}
