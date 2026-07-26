-- Completion engine (also supplies LSP client capabilities)
return {
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
}
