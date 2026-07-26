return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" },
		event = "VeryLazy",
		opts = {
			options = {
				theme = "auto",
				globalstatus = true,
				section_separators = "",
				component_separators = "",
			},
			sections = {
				lualine_c = { { "filename", path = 1 } }, -- relative path
				lualine_x = { "diagnostics", "encoding", "filetype" },
			},
		},
	},
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VimEnter",
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			dashboard.section.header.val = {
				"                                                     ",
				"  ███╗   ██╗██╗   ██╗██╗███╗   ███╗                  ",
				"  ████╗  ██║██║   ██║██║████╗ ████║                  ",
				"  ██╔██╗ ██║██║   ██║██║██╔████╔██║                  ",
				"  ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║                  ",
				"  ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║                  ",
				"  ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝                  ",
				"                                                     ",
			}

			dashboard.section.buttons.val = {
				dashboard.button("e", "  New file", "<cmd>ene<CR>"),
				dashboard.button("f", "  Find file", "<cmd>NvimTreeToggle<CR>"),
				dashboard.button("r", "  Recent files", "<cmd>oldfiles<CR>"),
				dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
			}

			alpha.setup(dashboard.opts)
		end,
	},
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		config = function()
			local notify = require("notify")
			notify.setup({ background_colour = "#1e1e2e", stages = "fade_in_slide_out" })
			vim.notify = notify
		end,
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({ options = { numbers = "ordinal" } })
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = { "BufReadPost", "BufNewFile" },
		opts = {},
	},
}
