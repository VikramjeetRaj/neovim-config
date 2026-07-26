-- =====================================================================
-- Go / Java / Gradle / Maven — nvim-dap adapters, configs and keymaps
-- =====================================================================

local util = require("config.util")

local M = {}

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
		local mvn = util.wrapper_or(maven_root, "mvnw", "mvnDebug")
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
		local gradle = util.wrapper_or(gradle_root, "gradlew", "gradle")
		jdb_attach_flow(gradle_root, { gradle, "run", "--debug-jvm" }, 5005)
	elseif vim.bo.filetype == "java" then
		jdb_file()
	else
		vim.notify("jdb: no pom.xml/build.gradle found and not a .java buffer", vim.log.levels.WARN)
	end
end

function M.setup()
	local dap = require("dap")

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
		{
			type = "delve",
			name = "Debug test (package)",
			request = "launch",
			mode = "test",
			program = "./${relativeFileDirname}",
		},
	}

	vim.keymap.set("n", "<leader>dg", function()
		dap.run(dap.configurations.go[1])
	end, { desc = "Debug: Go (current file)" })

	-- Java / Gradle / Maven via jdb
	vim.keymap.set("n", "<leader>dj", jdb_debug, { desc = "Debug: Java via jdb (auto file/gradle/maven)" })
	vim.keymap.set("n", "<leader>dJ", jdb_file, { desc = "Debug: Java single file via jdb" })
end

return M
