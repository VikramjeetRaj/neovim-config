-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Recommended: disable netrw when using nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true
vim.opt.timeoutlen = 1500

-- Disable mouse entirely
vim.opt.mouse = ""

-- Vim Buffer Switches

vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<leader>x", "<cmd>bdelete<cr>", { desc = "Close buffer" })

-- Folding

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99 -- start with everything expanded

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Line Number
vim.opt.number = true
vim.opt.relativenumber = true

-- Core editor settings
vim.opt.signcolumn = "yes" -- avoid layout shift from git/diagnostic signs
vim.opt.scrolloff = 8 -- keep cursor away from screen edges
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.ignorecase = true
vim.opt.smartcase = true -- case-sensitive only when the query has a capital
vim.opt.undofile = true -- persistent undo across sessions
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true

-- Tabs (not spaces) for languages that require them
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "go", "make" },
	callback = function()
		vim.bo.expandtab = false
	end,
})

-- Autosave (JetBrains-style): save on insert-leave, text change, buffer/focus loss
vim.opt.updatetime = 1000

local autosave_group = vim.api.nvim_create_augroup("AutoSave", { clear = true })
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "BufLeave", "FocusLost" }, {
	group = autosave_group,
	pattern = "*",
	callback = function()
		-- Only save normal, modifiable, named files (skip terminals, nvim-tree, etc.)
		if vim.bo.buftype == "" and vim.bo.modifiable and vim.fn.expand("%") ~= "" and vim.bo.modified then
			vim.cmd("silent! update")
		end
	end,
})
-- Plugins
require("lazy").setup({
	{
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
	},
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
	},
	{
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
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- file icons
		config = function()
			require("nvim-tree").setup({})
			vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })
		end,
	},
	{
		"stevearc/overseer.nvim",
		opts = {},
		cmd = { "OverseerRun", "OverseerToggle", "OverseerQuickAction" },
		keys = {
			{ "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run task" },
			{ "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Toggle task list" },
		},
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			formatters_by_ft = {
				cpp = { "clang_format" },
				c = { "clang_format" },
				go = { "goimports", "gofmt" },
				lua = { "stylua" },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback", -- use LSP formatter if no CLI formatter configured
			},
		},
	},
	{
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
	},

	-- Completion engine (also supplies LSP client capabilities)
	{
		"saghen/blink.cmp",
		version = "1.*",
		event = "InsertEnter",
		opts = {
			-- <C-space> open menu, <C-y> accept, <C-e> cancel, <C-n>/<C-p> select.
			-- Prefer preset = "super-tab" or "enter" if you want Tab/Enter to accept.
			keymap = { preset = "default" },
			appearance = { nerd_font_variant = "mono" },
			completion = { documentation = { auto_show = true, auto_show_delay_ms = 250 } },
			signature = { enabled = true },
			sources = { default = { "lsp", "path", "snippets", "buffer" } },
		},
		opts_extend = { "sources.default" },
	},

	-- LSP: Mason installs the servers, mason-lspconfig enables them (Neovim 0.11 native)
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			-- Give every server blink.cmp's completion capabilities.
			vim.lsp.config("*", {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			})

			-- Per-server tweaks (merged on top of nvim-lspconfig defaults).
			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			})
			vim.lsp.config("gopls", {
				settings = {
					gopls = {
						analyses = { unusedparams = true, nilness = true },
						staticcheck = true,
						gofumpt = true,
					},
				},
			})

			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "gopls", "clangd", "jdtls" },
			})

			-- Buffer-local keymaps whenever a server attaches.
			-- Note: Neovim 0.11 already provides grr (refs), grn (rename),
			-- gra (code action), gri (impl), gO (symbols), and K (hover).
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
				callback = function(ev)
					local map = function(keys, fn, desc)
						vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = desc })
					end
					map("gd", vim.lsp.buf.definition, "LSP: Definition")
					map("gD", vim.lsp.buf.declaration, "LSP: Declaration")
					map("<leader>rn", vim.lsp.buf.rename, "LSP: Rename")
					map("<leader>ca", vim.lsp.buf.code_action, "LSP: Code action")
					map("<leader>ld", vim.diagnostic.open_float, "Diagnostics: Line float")
					map("[d", function()
						vim.diagnostic.jump({ count = -1 })
					end, "Diagnostics: Prev")
					map("]d", function()
						vim.diagnostic.jump({ count = 1 })
					end, "Diagnostics: Next")
				end,
			})
		end,
	},

	-- Fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
			{ "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
			{ "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
			{ "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Grep word under cursor" },
		},
		config = function()
			require("telescope").setup({})
			pcall(require("telescope").load_extension, "fzf")
		end,
	},

	-- Git gutter signs, blame, hunk actions
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			on_attach = function(bufnr)
				local gs = require("gitsigns")
				local map = function(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
				end
				map("n", "]h", function()
					gs.nav_hunk("next")
				end, "Next hunk")
				map("n", "[h", function()
					gs.nav_hunk("prev")
				end, "Prev hunk")
				map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
				map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
				map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
				map("n", "<leader>hb", function()
					gs.blame_line({ full = true })
				end, "Blame line")
				map("n", "<leader>hB", gs.toggle_current_line_blame, "Toggle line blame")
				map("n", "<leader>hd", gs.diffthis, "Diff this")
			end,
		},
	},

	-- Quality-of-life
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		opts = {},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = { "BufReadPost", "BufNewFile" },
		opts = {},
	},
})

-- Overseer Configs

local overseer = require("overseer")
overseer.setup({})

-- keymaps
vim.keymap.set("n", "<leader>or", "<cmd>OverseerRun<cr>", { desc = "Run task" })
vim.keymap.set("n", "<leader>ot", "<cmd>OverseerToggle<cr>", { desc = "Toggle task list" })

-- build + run
overseer.register_template({
	name = "C++ build & run",
	condition = { filetype = { "cpp" } },
	builder = function()
		local file = vim.fn.expand("%:p")
		local out = vim.fn.expand("%:p:r")
		return {
			cmd = { "sh", "-c", string.format("g++ -std=c++23 -g -Wall '%s' -o '%s' && '%s'", file, out, out) },
			components = {
				{ "on_output_quickfix", open = true },
				"default",
			},
		}
	end,
})

-- build only (debug)
overseer.register_template({
	name = "C++ build (debug)",
	condition = { filetype = { "cpp" } },
	builder = function()
		local file = vim.fn.expand("%:p")
		local out = vim.fn.expand("%:p:r")
		return {
			cmd = { "g++" },
			args = { "-std=c++23", "-g", "-O0", "-Wall", file, "-o", out },
			components = {
				{ "on_output_quickfix", open = true },
				"default",
			},
		}
	end,
})

-- Build (via Overseer "C++ build (debug)" task) then launch nvim-dap on the resulting binary
local function build_and_debug()
	local dap = require("dap")
	local out = vim.fn.expand("%:p:r")

	overseer.run_task({ name = "C++ build (debug)" }, function(task)
		if not task then
			vim.notify("Could not start C++ build (debug) task", vim.log.levels.ERROR)
			return
		end
		task:subscribe("on_complete", function(_, status)
			if status == overseer.STATUS.SUCCESS then
				dap.run({
					name = "Launch (Overseer build)",
					type = "lldb",
					request = "launch",
					program = out,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = {},
				})
			else
				vim.notify("Build failed, not launching debugger", vim.log.levels.ERROR)
			end
		end)
	end)
end

vim.keymap.set("n", "<leader>dc", build_and_debug, { desc = "Debug: Build (Overseer) & Launch" })

-- =====================================================================
-- Go / Java / Gradle / Maven — Overseer run tasks + nvim-dap debugging
-- =====================================================================

local dap = require("dap")

-- Small helpers ------------------------------------------------------
local default_components = {
	{ "on_output_quickfix", open = true },
	"default",
}

-- Find the nearest ancestor dir containing any of `markers`, or cwd.
local function project_root(markers)
	return vim.fs.root(0, markers) or vim.fn.getcwd()
end

-- Prefer a project wrapper script (gradlew/mvnw) over the global tool.
local function wrapper_or(root, wrapper, fallback)
	local path = root .. "/" .. wrapper
	if vim.fn.filereadable(path) == 1 then
		return path
	end
	return fallback
end

-- ------------------------------------------------------------------
-- Go: Overseer run/build/test tasks
-- ------------------------------------------------------------------
overseer.register_template({
	name = "Go run (file)",
	condition = { filetype = { "go" } },
	builder = function()
		return {
			cmd = { "go" },
			args = { "run", vim.fn.expand("%:p") },
			components = default_components,
		}
	end,
})

overseer.register_template({
	name = "Go run (package)",
	condition = { filetype = { "go" } },
	builder = function()
		return {
			cmd = { "go" },
			args = { "run", "." },
			cwd = vim.fn.expand("%:p:h"),
			components = default_components,
		}
	end,
})

overseer.register_template({
	name = "Go test (package)",
	condition = { filetype = { "go" } },
	builder = function()
		return {
			cmd = { "go" },
			args = { "test", "-v", "./..." },
			cwd = project_root({ "go.mod", ".git" }),
			components = default_components,
		}
	end,
})

overseer.register_template({
	name = "Go build",
	condition = { filetype = { "go" } },
	builder = function()
		return {
			cmd = { "go" },
			args = { "build", "./..." },
			cwd = project_root({ "go.mod", ".git" }),
			components = default_components,
		}
	end,
})

-- ------------------------------------------------------------------
-- Java: Overseer run tasks (single-file launcher + compile & run)
-- ------------------------------------------------------------------
overseer.register_template({
	name = "Java run (single file)", -- JDK 11+ source-file mode
	condition = { filetype = { "java" } },
	builder = function()
		return {
			cmd = { "java" },
			args = { vim.fn.expand("%:p") },
			components = default_components,
		}
	end,
})

overseer.register_template({
	name = "Java compile & run",
	condition = { filetype = { "java" } },
	builder = function()
		local file = vim.fn.expand("%:p")
		local class = vim.fn.expand("%:t:r")
		local outdir = vim.fn.stdpath("cache") .. "/java-out"
		return {
			cmd = {
				"sh",
				"-c",
				string.format(
					"mkdir -p '%s' && javac -d '%s' '%s' && java -cp '%s' %s",
					outdir,
					outdir,
					file,
					outdir,
					class
				),
			},
			components = default_components,
		}
	end,
})

-- ------------------------------------------------------------------
-- Gradle: Overseer tasks (gradlew-aware)
-- ------------------------------------------------------------------
local gradle_markers = { "gradlew", "build.gradle", "build.gradle.kts", "settings.gradle", "settings.gradle.kts" }
local function is_gradle_project()
	return vim.fs.root(0, gradle_markers) ~= nil
end

local function gradle_task(name, gradle_args)
	overseer.register_template({
		name = name,
		condition = { callback = is_gradle_project },
		builder = function()
			local root = project_root(gradle_markers)
			return {
				cmd = { wrapper_or(root, "gradlew", "gradle") },
				args = gradle_args,
				cwd = root,
				components = default_components,
			}
		end,
	})
end

gradle_task("Gradle build", { "build" })
gradle_task("Gradle run", { "run" })
gradle_task("Gradle test", { "test" })

-- ------------------------------------------------------------------
-- Maven: Overseer tasks (mvnw-aware)
-- ------------------------------------------------------------------
local maven_markers = { "mvnw", "pom.xml" }
local function is_maven_project()
	return vim.fs.root(0, maven_markers) ~= nil
end

local function maven_task(name, maven_args)
	overseer.register_template({
		name = name,
		condition = { callback = is_maven_project },
		builder = function()
			local root = project_root(maven_markers)
			return {
				cmd = { wrapper_or(root, "mvnw", "mvn") },
				args = maven_args,
				cwd = root,
				components = default_components,
			}
		end,
	})
end

maven_task("Maven package", { "package" })
maven_task("Maven test", { "test" })
maven_task("Maven run (exec:java)", { "compile", "exec:java" })

-- ------------------------------------------------------------------
-- Go: nvim-dap debugging via Delve (requires `dlv` on PATH)
--   install: go install github.com/go-delve/delve/cmd/dlv@latest
-- ------------------------------------------------------------------
dap.adapters.delve = function(callback, config)
	if config.mode == "remote" and config.request == "attach" then
		callback({
			type = "server",
			host = config.host or "127.0.0.1",
			port = config.port or "38697",
		})
	else
		callback({
			type = "server",
			port = "${port}",
			executable = {
				command = "dlv",
				args = { "dap", "-l", "127.0.0.1:${port}", "--log", "--log-output=dap" },
			},
		})
	end
end

dap.configurations.go = {
	{ type = "delve", name = "Debug (current file)", request = "launch", program = "${file}" },
	{ type = "delve", name = "Debug (package)", request = "launch", program = "./${relativeFileDirname}" },
	{ type = "delve", name = "Debug test (file)", request = "launch", mode = "test", program = "${file}" },
	{ type = "delve", name = "Debug test (package)", request = "launch", mode = "test", program = "./${relativeFileDirname}" },
}

vim.keymap.set("n", "<leader>dg", function()
	dap.run(dap.configurations.go[1])
end, { desc = "Debug: Go (current file)" })

-- ------------------------------------------------------------------
-- Java / Gradle / Maven: debugging via jdb (the JDK command-line debugger)
--   No plugins/bundles needed — jdb ships with the JDK. It runs in a
--   terminal split (no dap-ui gutter). Common commands at the `>` prompt:
--     stop at MyClass:42       breakpoint at a line
--     stop in MyClass.main     breakpoint on method entry
--     run                      start (single-file mode)
--     cont / step / next       continue / step into / step over
--     locals / print <expr>    inspect state
--     exit                     quit
-- ------------------------------------------------------------------

-- Open a bottom terminal split running argv (a list) in `cwd`.
local function open_term(argv, cwd)
	vim.cmd("botright new")
	vim.api.nvim_win_set_height(0, 16)
	if vim.fn.has("nvim-0.11") == 1 then
		vim.fn.jobstart(argv, { term = true, cwd = cwd })
	else
		vim.fn.termopen(argv, { cwd = cwd })
	end
	vim.cmd("startinsert")
end

-- POSIX single-quote for safe embedding inside `sh -c`.
local function shq(s)
	return "'" .. tostring(s):gsub("'", "'\\''") .. "'"
end

-- Debug a standalone .java file: compile with -g, then launch it under jdb.
local function jdb_file()
	local file = vim.fn.expand("%:p")
	local class = vim.fn.expand("%:t:r")
	local out = vim.fn.stdpath("cache") .. "/java-out"
	local script = table.concat({
		"mkdir -p " .. shq(out),
		"javac -g -d " .. shq(out) .. " " .. shq(file),
		"jdb -classpath " .. shq(out) .. " " .. class,
	}, " && ")
	open_term({ "sh", "-c", script })
end

-- Start a suspended JVM (terminal 1) and attach jdb once the port opens (terminal 2).
local function jdb_attach_flow(root, launch_argv, port)
	local src = root .. "/src/main/java"
	local sourcepath = vim.fn.isdirectory(src) == 1 and (" -sourcepath " .. shq(src)) or ""
	open_term(launch_argv, root) -- terminal 1: the app, suspended, listening
	local waiter = string.format(
		"echo 'waiting for JVM on port %s...'; "
			.. "until nc -z localhost %s 2>/dev/null; do sleep 0.3; done; "
			.. "jdb -attach %s%s",
		port,
		port,
		port,
		sourcepath
	)
	open_term({ "sh", "-c", waiter }, root) -- terminal 2: wait for port, then attach jdb
end

-- Smart entry point: Maven project -> Gradle project -> single file.
local function jdb_debug()
	local maven_root = vim.fs.root(0, { "mvnw", "pom.xml" })
	local gradle_root = vim.fs.root(0, { "gradlew", "build.gradle", "build.gradle.kts", "settings.gradle" })

	if maven_root then
		-- mvnDebug suspends on port 8000; with a wrapper, pass jdwp via MAVEN_OPTS.
		local mvn = wrapper_or(maven_root, "mvnw", "mvnDebug")
		local argv
		if mvn:match("mvnw$") then
			argv = {
				"sh",
				"-c",
				"MAVEN_OPTS='-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8000' "
					.. shq(mvn)
					.. " compile exec:java",
			}
		else
			argv = { mvn, "compile", "exec:java" }
		end
		jdb_attach_flow(maven_root, argv, 8000)
	elseif gradle_root then
		-- `run --debug-jvm` suspends on port 5005 (needs the application plugin).
		local gradle = wrapper_or(gradle_root, "gradlew", "gradle")
		jdb_attach_flow(gradle_root, { gradle, "run", "--debug-jvm" }, 5005)
	elseif vim.bo.filetype == "java" then
		jdb_file()
	else
		vim.notify("jdb: no pom.xml/build.gradle found and not a .java buffer", vim.log.levels.WARN)
	end
end

vim.keymap.set("n", "<leader>dj", jdb_debug, { desc = "Debug: Java via jdb (auto file/gradle/maven)" })
vim.keymap.set("n", "<leader>dJ", jdb_file, { desc = "Debug: Java single file via jdb" })
