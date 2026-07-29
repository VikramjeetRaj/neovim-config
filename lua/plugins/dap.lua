return {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		"mfussenegger/nvim-dap",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dap, dapui = require("dap"), require("dapui")
		dapui.setup()

		-- Breakpoint sign icons (nvim-dap doesn't define these by default)
		vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
		vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
		vim.fn.sign_define("DapBreakpointRejected", { text = "✗", texthl = "DiagnosticError", linehl = "", numhl = "" })
		vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo", linehl = "CursorLine", numhl = "" })
		vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DiagnosticInfo", linehl = "", numhl = "" })

		-- Auto-open/close the UI when debugging starts/stops
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		-- lldb-dap adapter (ships with Xcode Command Line Tools)
		local lldb_dap_path = vim.fn.exepath("lldb-dap")
		if lldb_dap_path == "" then
			lldb_dap_path = vim.fn.trim(vim.fn.system("xcrun -f lldb-dap"))
		end

		dap.adapters.lldb = {
			type = "executable",
			command = lldb_dap_path,
			name = "lldb",
		}

		dap.configurations.cpp = {
			{
				name = "Launch",
				type = "lldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.expand("%:p:r"), "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				args = {},
				-- Feed input.txt to the program's stdin while debugging, if present.
				-- Evaluated at launch time (functions are resolved by nvim-dap).
				stdio = function()
					return require("config.util").lldb_stdin_fields().stdio
				end,
				preRunCommands = function()
					return require("config.util").lldb_stdin_fields().preRunCommands
				end,
			},
		}
		dap.configurations.c = dap.configurations.cpp

		-- Debug keymaps
		vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Continue" })
		vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
		vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
		vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
		vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
		vim.keymap.set("n", "<leader>dB", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Debug: Conditional Breakpoint" })
		vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Debug: Open REPL" })
		vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Debug: Run Last" })
		vim.keymap.set("n", "<leader>dq", function()
			dap.terminate()
			dapui.close()
		end, { desc = "Debug: Terminate" })
		vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Debug: Toggle UI" })

		-- Go / Java / Gradle / Maven adapters, configs and keymaps
		require("config.dap_config").setup()
	end,
}
