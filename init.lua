-- Bootstrap lazy.nvim
vim.env.PATH = vim.fn.expand("~/.cargo/bin") .. ":" .. vim.env.PATH

-- Bootstrap ripgrep (needed by Telescope live_grep) via rustup + cargo.
-- Blocking: first run pays a one-time cargo build cost before nvim opens.
if vim.fn.executable("rg") == 0 then
        if vim.fn.executable("cargo") == 0 then
                vim.fn.system("curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y")
                if vim.v.shell_error ~= 0 then
                        vim.notify("rustup install failed; ripgrep was not installed", vim.log.levels.ERROR)
                end
        end

        if vim.fn.executable("cargo") == 1 then
                vim.fn.system("cargo install ripgrep")
                if vim.v.shell_error ~= 0 then
                        vim.notify("cargo install ripgrep failed", vim.log.levels.ERROR)
                end
        end
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
                "git",
                "clone",
                "--filter=blob:none",
                "https://github.com/folke/lazy.nvim.git",
                "--branch=stable",
                lazypath,
        })
end
vim.opt.rtp:prepend(lazypath)

-- Core editor config (options must load before plugins so e.g. netrw is
-- disabled before nvim-tree, and folding uses treesitter once available).
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Plugins: every file under lua/plugins/ returns a lazy.nvim spec.
require("lazy").setup({
        { import = "plugins" },
})
