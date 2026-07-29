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
		-- Keep the formatters' indent width in sync with the editor (8 spaces),
		-- so autosave/format-on-save doesn't rewrite your indentation to some
		-- other width. (Go uses tabs by convention, so it's left as-is.)
		formatters = {
			clang_format = {
				prepend_args = { "--style={BasedOnStyle: LLVM, IndentWidth: 8, TabWidth: 8, UseTab: Never}" },
			},
			stylua = {
				prepend_args = { "--indent-type", "Spaces", "--indent-width", "8" },
			},
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback", -- use LSP formatter if no CLI formatter configured
		},
	},
}
