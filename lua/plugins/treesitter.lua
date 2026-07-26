return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "json", "jsonc", "lua", "go", "vim", "vimdoc", "cpp", "c", "java" },
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
