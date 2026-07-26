return {
	"akinsho/toggleterm.nvim",
	version = "*",
	opts = {
		open_mapping = [[<c-\>]], -- Ctrl-\ toggles the terminal
		direction = "float", -- "float" | "horizontal" | "vertical" | "tab"
		float_opts = { border = "curved" },
		size = function(term)
			if term.direction == "horizontal" then
				return 15
			elseif term.direction == "vertical" then
				return math.floor(vim.o.columns * 0.4)
			end
		end,
	},
}
