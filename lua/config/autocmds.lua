-- Autocommands

-- Tabs (not spaces) for languages that require them
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "go", "make" },
	callback = function()
		vim.bo.expandtab = false
	end,
})

-- Autosave (JetBrains-style): save on insert-leave, text change, buffer/focus loss
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
