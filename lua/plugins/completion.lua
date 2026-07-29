-- Completion engine (also supplies LSP client capabilities)
return {
	"saghen/blink.cmp",
	version = "1.*",
	event = "InsertEnter",
	opts = {
		-- Tab OR Enter accept the highlighted item; Tab also jumps snippet
		-- fields and falls back to a normal Tab when the menu is closed.
		-- <C-space> toggles the menu, <C-e> hides it, <C-n>/<C-p> move.
		keymap = {
			preset = "super-tab",
			["<CR>"] = { "accept", "fallback" },
		},
		appearance = { nerd_font_variant = "mono" },
		completion = {
			-- Preselect the top item so Tab/Enter always have something to accept.
			list = { selection = { preselect = true, auto_insert = false } },
			-- Show the menu automatically and preview the top item inline.
			menu = { auto_show = true },
			ghost_text = { enabled = true },
			documentation = { auto_show = true, auto_show_delay_ms = 250 },
		},
		signature = { enabled = true },
		sources = { default = { "lsp", "path", "snippets", "buffer" } },
	},
	opts_extend = { "sources.default" },
}
