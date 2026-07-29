-- Shared helpers used by overseer tasks and DAP config

local M = {}

-- Find the nearest ancestor dir containing any of `markers`, or cwd.
function M.project_root(markers)
	return vim.fs.root(0, markers) or vim.fn.getcwd()
end

-- Prefer a project wrapper script (gradlew/mvnw) over the global tool.
function M.wrapper_or(root, wrapper, fallback)
	local path = root .. "/" .. wrapper
	if vim.fn.filereadable(path) == 1 then
		return path
	end
	return fallback
end

-- Locate an input.txt to feed to a program's stdin. Checks next to the current
-- source file first, then the working directory. Returns the absolute path, or
-- nil if none is found.
function M.find_input_txt()
	local candidates = {
		vim.fn.expand("%:p:h") .. "/input.txt",
		vim.fn.getcwd() .. "/input.txt",
	}
	for _, p in ipairs(candidates) do
		if vim.fn.filereadable(p) == 1 then
			return p
		end
	end
	return nil
end

-- Build the lldb-dap launch fields that redirect stdin from input.txt, if one
-- exists. Sets both `stdio` (lldb-dap >= 22.0) and a `target.input-path`
-- preRunCommand (older lldb-dap, e.g. Xcode's) so at least one takes effect.
-- Returns an empty table when there is no input.txt (run with normal stdin).
function M.lldb_stdin_fields()
	local input = M.find_input_txt()
	if not input then
		return {}
	end
	return {
		stdio = { input },
		preRunCommands = { "settings set target.input-path " .. vim.fn.shellescape(input) },
	}
end

return M
