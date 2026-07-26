return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000, -- load before other plugins so their theming can hook into it
	opts = {
		flavour = "mocha",
		integrations = {
			bufferline = true,
			nvim_tree = true,
			treesitter = true,
			dap = true,
			dap_ui = true,
			notify = true,
			which_key = true,
			telescope = true,
			gitsigns = true,
			mason = true,
			blink_cmp = true,
			native_lsp = { enabled = true },
			indent_blankline = { enabled = true },
		},
	},
	config = function(_, opts)
		require("catppuccin").setup(opts)
		vim.cmd.colorscheme("catppuccin-mocha")
	end,
}
