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
			require("bufferline").setup({
				options = {
					numbers = "ordinal",
					-- Slanted tab edges for a more graphical look
					separator_style = "slant",
					-- Filetype icons, colored per language
					show_buffer_icons = true,
					color_icons = true,
					-- Close buttons on tabs and at the far right
					show_buffer_close_icons = true,
					show_close_icon = true,
					buffer_close_icon = "󰅖",
					close_icon = "",
					-- A thick colored bar marks the active tab
					indicator = { style = "underline" },
					-- Inline LSP error/warning badges on each tab
					diagnostics = "nvim_lsp",
					diagnostics_indicator = function(count, level)
						local icon = level:match("error") and " " or " "
						return " " .. icon .. count
					end,
					-- Roomier tabs
					tab_size = 20,
					-- Keep tabs clear of the file-explorer sidebar with a titled offset
					offsets = {
						{
							filetype = "NvimTree",
							text = "File Explorer",
							text_align = "center",
							separator = true,
						},
					},
				},
			})
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
