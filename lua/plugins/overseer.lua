return {
	"stevearc/overseer.nvim",
	cmd = { "OverseerRun", "OverseerToggle", "OverseerQuickAction" },
	keys = {
		{ "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run task" },
		{ "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Toggle task list" },
		{
			"<leader>dc",
			function()
				require("config.overseer_tasks").build_and_debug()
			end,
			desc = "Debug: Build (Overseer) & Launch",
		},
	},
	config = function()
		require("overseer").setup({})
		-- Register C++ / Go / Java / Gradle / Maven task templates
		require("config.overseer_tasks").setup()
	end,
}
