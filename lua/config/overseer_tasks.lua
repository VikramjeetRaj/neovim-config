-- =====================================================================
-- Overseer run/build/test task templates for C++ / Go / Java / Gradle / Maven
-- =====================================================================

local util = require("config.util")

local M = {}

-- Shared component list for task output -> quickfix.
local default_components = {
	{ "on_output_quickfix", open = true },
	"default",
}

-- Build (via Overseer "C++ build (debug)" task) then launch nvim-dap on the resulting binary.
function M.build_and_debug()
	local overseer = require("overseer")
	local dap = require("dap")
	local out = vim.fn.expand("%:p:r")
	-- Resolve input.txt now (while the C++ buffer is active), since the build
	-- runs asynchronously and the active buffer may change before it completes.
	local stdin_fields = require("config.util").lldb_stdin_fields()

	overseer.run_task({ name = "C++ build (debug)" }, function(task)
		if not task then
			vim.notify("Could not start C++ build (debug) task", vim.log.levels.ERROR)
			return
		end
		task:subscribe("on_complete", function(_, status)
			if status == overseer.STATUS.SUCCESS then
				dap.run(vim.tbl_extend("error", {
					name = "Launch (Overseer build)",
					type = "lldb",
					request = "launch",
					program = out,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = {},
				}, stdin_fields))
			else
				vim.notify("Build failed, not launching debugger", vim.log.levels.ERROR)
			end
		end)
	end)
end

-- Register all task templates. Safe to call once when overseer loads.
function M.setup()
	local overseer = require("overseer")

	-- ------------------------------------------------------------------
	-- C++: build & run / build only (debug)
	-- ------------------------------------------------------------------
	-- Single build & run task: compiles, then runs. If an input.txt exists next
	-- to the source or in the working directory, it's fed to the program's stdin
	-- (cin). A visible notice prints which file was used, or that none was found
	-- (in which case the program just runs with no stdin). One task, so there's
	-- no "wrong" variant to accidentally pick.
	overseer.register_template({
		name = "C++ build & run",
		condition = { filetype = { "cpp" } },
		builder = function()
			local file = vim.fn.expand("%:p")
			local out = vim.fn.expand("%:p:r")
			local dir = vim.fn.expand("%:p:h")
			local run = string.format(
				"g++ -std=c++23 -g -Wall '%s' -o '%s' && "
					.. "if [ -f '%s/input.txt' ]; then echo '[stdin: %s/input.txt]'; '%s' < '%s/input.txt'; "
					.. "elif [ -f input.txt ]; then echo \"[stdin: $(pwd)/input.txt]\"; '%s' < input.txt; "
					.. "else echo '[no input.txt found near source or in cwd; running with no stdin]'; '%s'; fi",
				file,
				out,
				dir,
				dir,
				out,
				dir,
				out,
				out
			)
			return {
				cmd = { "sh", "-c", run },
				cwd = dir,
				components = {
					{ "on_output_quickfix", open = true },
					"default",
				},
			}
		end,
	})

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
				cwd = util.project_root({ "go.mod", ".git" }),
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
				cwd = util.project_root({ "go.mod", ".git" }),
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
				local root = util.project_root(gradle_markers)
				return {
					cmd = { util.wrapper_or(root, "gradlew", "gradle") },
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
				local root = util.project_root(maven_markers)
				return {
					cmd = { util.wrapper_or(root, "mvnw", "mvn") },
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
end

return M
