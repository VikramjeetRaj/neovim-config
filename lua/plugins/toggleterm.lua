-- IntelliJ-style terminal: a docked panel at the bottom that toggles with a
-- key, keeps its shell alive while hidden, and has a tab strip for multiple
-- sessions (like the "Local", "Local (2)" tabs in IntelliJ's Terminal window).
return {
	"akinsho/toggleterm.nvim",
	version = "*",
	opts = {
		open_mapping = [[<c-\>]], -- Ctrl-\ toggles the terminal (also works from inside it)
		direction = "horizontal", -- docked at the bottom, like IntelliJ's tool window
		size = function(term)
			if term.direction == "horizontal" then
				return math.floor(vim.o.lines * 0.3)
			elseif term.direction == "vertical" then
				return math.floor(vim.o.columns * 0.4)
			end
		end,
		shade_terminals = false,
		persist_size = true,
		persist_mode = false, -- always reopen in insert mode, ready to type
		start_in_insert = true,
		close_on_exit = true,
		float_opts = { border = "curved" },
		-- Tab strip along the top of the panel; click a tab to switch terminals.
		winbar = {
			enabled = true,
			name_formatter = function(term)
				return term.id == 1 and "Local" or ("Local (" .. term.id .. ")")
			end,
		},
	},
	config = function(_, opts)
		require("toggleterm").setup(opts)

		local map = vim.keymap.set

		-- IntelliJ's Alt+F12 (Option+F12 on macOS). Plain <F12> is DAP "step out".
		map({ "n", "t" }, "<A-F12>", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })

		-- Extra sessions ("tabs"): <leader>t1, <leader>t2, ... each is its own shell.
		for i = 1, 4 do
			map("n", "<leader>t" .. i, "<cmd>" .. i .. "ToggleTerm<cr>", { desc = "Terminal " .. i })
		end
		map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Floating terminal" })
		map("n", "<leader>ta", "<cmd>ToggleTermToggleAll<cr>", { desc = "Toggle all terminals" })
		map("n", "<leader>ts", "<cmd>TermSelect<cr>", { desc = "Pick a terminal" })

		-- Inside a terminal: <Esc><Esc> to normal mode, Ctrl+h/j/k/l to leave the panel.
		vim.api.nvim_create_autocmd("TermOpen", {
			pattern = "term://*toggleterm#*",
			callback = function(ev)
				local o = { buffer = ev.buf }
				map("t", "<Esc><Esc>", [[<C-\><C-n>]], o)
				map("t", "<C-h>", [[<Cmd>wincmd h<CR>]], o)
				map("t", "<C-j>", [[<Cmd>wincmd j<CR>]], o)
				map("t", "<C-k>", [[<Cmd>wincmd k<CR>]], o)
				map("t", "<C-l>", [[<Cmd>wincmd l<CR>]], o)
			end,
		})
	end,
}
