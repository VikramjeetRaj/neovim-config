return {
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
}
