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

return M
