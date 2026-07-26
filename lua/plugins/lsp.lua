-- LSP: Mason installs the servers, mason-lspconfig enables them (Neovim 0.11 native)
return {
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
}
