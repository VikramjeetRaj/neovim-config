return {
	"nvim-tree/nvim-tree.lua",
	dependencies = { "nvim-tree/nvim-web-devicons" }, -- file icons
	config = function()
		require("nvim-tree").setup({})
		vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })
	end,
}
