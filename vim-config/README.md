# Vim Configuration — Guide

A modular Vim version of `~/Desktop/neovim-config`, preserving its backslash leader, editing settings, shortcuts, language workflows, and Catppuccin Mocha appearance as closely as Vim permits. This is Vimscript throughout; Neovim and Lua are not required.

## Contents

1. [What is this?](#what-is-this)
2. [Key terms](#key-terms)
3. [How to read shortcuts](#how-to-read-shortcuts)
4. [First-time setup](#first-time-setup)
5. [Editor behaviour](#editor-behaviour)
6. [Keyboard shortcuts](#keyboard-shortcuts)
7. [Running and building code](#running-and-building-code)
8. [Debugging](#debugging)
9. [Plugins and equivalents](#plugins-and-equivalents)
10. [File layout](#file-layout)
11. [External tools](#external-tools)
12. [Nerd Font](#nerd-font)
13. [Differences from Neovim](#differences-from-neovim)
14. [Troubleshooting](#troubleshooting)
15. [Validation](#validation)
16. [Changelog](#changelog)

## What is this?

Vim is a keyboard-driven text editor. These files add a file sidebar, a strip of open buffers, completion, code navigation, diagnostics, Git tools, multiple terminal sessions, build tasks, and debugging for C/C++, Go, Java, Gradle, Maven, and Lua editing.

Use a modern **Vim 9.1 or newer** with `+terminal`, `+job`, `+channel`, `+timers`, `+popupwin`, and `+textprop`. C/C++ and Go graphical debugging additionally need `+python3`, backed by Python 3.10 or newer, for Vimspector. Clipboard sharing needs `+clipboard`. Run `vim --version` to check. The `/usr/bin/vim` supplied on this Mac has the core features but lacks `+python3`; use a full Vim build for graphical debugging.

The source Neovim config is untouched. Running `scripts/bootstrap.sh` installs this setup as your default `~/.vimrc`. It moves an existing vimrc to `~/.vimrc.old`, deleting any older backup first.

## Key terms

| Term | Meaning |
|---|---|
| Normal mode | Keys perform commands. Press `Esc` to return here. |
| Insert mode | Keys type text. Press `i` to enter. |
| Leader | Prefix for a group of shortcuts; backslash in this setup. |
| Buffer | An open file, which can stay open without being visible. |
| Window / split | A pane showing a buffer. |
| Tab page | A group of windows. The debugger uses its own tab page. |
| LSP / language server | A program that understands code and supplies completion and navigation. |
| Diagnostic | A warning or error from a language server. |
| Quickfix | A list of compiler messages or search results; Enter jumps to a location. |
| Task | A build, run, or test command launched in the background. |
| Breakpoint | A source line where execution pauses. |
| Hunk | A block of changed lines in Git. |
| Formatter | A tool that tidies source code when saving. |
| PATH | Directories searched for external programs. |

## How to read shortcuts

`<leader>` means **backslash `\`**. `<leader>ff` means press `\`, `f`, `f` in Normal mode. `<C-h>` means Ctrl+h; `<S-l>` means capital `L`; `<CR>` means Enter; `<A-F12>` means Alt/Option+F12. Function keys on a Mac may require `Fn`.

The timeout is 1.5 seconds. After plugins are installed, pausing after the leader shows the which-key menu. To switch to Space, add `let mapleader = ' '` near the top of `config/options.vim`, before mappings are loaded.

## First-time setup

1. Install Vim and the external tools for the languages you use. On macOS with Homebrew:

   ```sh
   brew install vim node ripgrep fzf
   ```

   Homebrew is not installed by this configuration. Make sure the installed Vim appears before `/usr/bin/vim` on your PATH. Reopen the shell or run `hash -r`, then check `command -v vim` and `vim --version`.

2. Install the plugin manager and open this configuration explicitly:

   ```sh
   sh ~/Desktop/vim-config/scripts/bootstrap.sh
   vim
   ```

3. Run `:PlugInstall`, wait for it to finish, then restart with `vim`. First launch after installation lets CoC install its configured language extensions. This needs network access and Node.js. Bootstrap installs vim-plug and copies the entry point to `~/.vimrc`; startup itself never installs a compiler, Rust toolchain, or ripgrep.

4. Run `:CocInfo` and `:CocList extensions` to check completion and language extensions. Run `:VimConfigHealth` for local feature/tool checks. `:messages` shows earlier notices.

5. Bootstrap has already made this your default configuration: use `vim` normally. Your previous `~/.vimrc` is saved as `~/.vimrc.old` when one existed. Each bootstrap rerun replaces that backup with the current vimrc. If no current vimrc exists, an existing backup is preserved.

   The installed entry point pins the module directory to this configuration folder, so keep the folder in place. Run bootstrap again after moving it or changing `vimrc`; edits to modules take effect on the next Vim launch. You can still use `vim -u ~/Desktop/vim-config/vimrc` explicitly.

Plugin code lives in `~/.local/share/vim-config/plugged`; undo, swap, backups, and compiled Java output live in `~/.local/state/vim-config`. The configuration folder contains only editable configuration and docs. To relocate plugin data, set `g:vim_config_data` before sourcing `vimrc`, and pass the same path as `VIM_CONFIG_DATA` when running bootstrap. Set `g:vim_config_state` to relocate state.

## Editor behaviour

| Setting | Behaviour |
|---|---|
| Theme | Catppuccin Mocha, true colour, dark background |
| Mouse | Disabled |
| Line numbers | Absolute; relative numbers disabled |
| Gutter | Always visible to avoid horizontal jumps |
| Cursor and scrolling | Highlight current line, keep 8 lines of context |
| Long lines | No wrapping |
| Search | Case-insensitive unless the query contains a capital |
| Indentation | 8 spaces for Tab, soft Tab, and indent operations |
| Go / Make | Real tabs, still displayed at width 8 |
| New lines | Automatic/smart indentation, plus Vim filetype indent rules |
| Splits | New vertical panes on the right, horizontal panes below |
| Clipboard | Shared through `unnamedplus` when Vim supports clipboard |
| Undo | Persistent across sessions, stored outside the repository |
| Folding | Vim syntax folding; all folds start expanded (`foldlevel=99`) |
| Autosave | On InsertLeave, TextChanged, BufLeave, FocusLost |
| Save guard | Only named, normal, modifiable, non-readonly buffers |
| Formatting | Before writes; command-line formatter, otherwise available LSP formatter |

Autosave also triggers formatting. C/C++ uses `clang-format` with LLVM style, 8-space indentation, and no tabs. Go uses `goimports` followed by `gofmt` when installed. Lua uses StyLua with 8 spaces. Formatter errors preserve the original buffer and appear in `:messages`. CLI formatting is synchronous; large files can delay saving. Project formatter settings other than those flags remain controlled by the formatter.

## Keyboard shortcuts

All rows are Normal mode unless specified. Plugin actions need `:PlugInstall` and the relevant language server or external tool.

### Buffers and windows

| Key | Action |
|---|---|
| `L` / `H` | Next / previous listed buffer |
| `<leader>x` | Close buffer |
| `<C-h/j/k/l>` | Move left / down / up / right between windows |
| `<leader>sv` / `<leader>sh` | Vertical / horizontal split |
| `<leader>se` | Equalize window sizes |
| `<leader>sc` / `<leader>so` | Close window / close other windows |
| `<C-Up>` / `<C-Down>` | Height +2 / −2 |
| `<C-Left>` / `<C-Right>` | Width −2 / +2 |

### Explorer and finding things

| Key | Action |
|---|---|
| `<leader>e` | Toggle NERDTree sidebar |
| `<leader>ff` | Fuzzy file finder |
| `<leader>fg` | Live project search with ripgrep, refreshed as you type |
| `<leader>fb` | Buffer picker |
| `<leader>fr` | Recent file picker |
| `<leader>fh` | Help tags |
| `<leader>fs` / `gO` | Document symbols (CoC outline) |
| `<leader>fd` | Workspace diagnostics (CoC list) |
| `<leader>fw` | Search for word under cursor |

In NERDTree, Enter opens a file or expands a folder, `s` opens a vertical split, `i` opens a horizontal split, `t` opens a tab, `m` opens its file operations menu, and `?` shows help. In fzf, type to narrow candidates, Ctrl+n/Ctrl+p move, Enter selects, and Esc cancels. File and text searches start at Vim's current working directory (`:pwd`); use `:cd /path/to/project` to change it.

### Completion and language intelligence

| Key | Action |
|---|---|
| `gd` / `gD` | Definition / declaration |
| `K` | Hover documentation |
| `grr` / `gri` | References / implementations |
| `<leader>rn` / `grn` | Rename symbol |
| `<leader>ca` / `gra` | Code action at cursor |
| `<leader>ld` | Current line diagnostics |
| `[d` / `]d` | Previous / next diagnostic |
| Insert: Tab / Enter | Accept selected completion |
| Insert: Tab with menu closed | Expand/jump snippet if available, otherwise insert Tab |
| Insert: Shift+Tab | Previous menu item; otherwise backspace |
| Insert: Ctrl+Space | Open/close completion menu |
| Insert: Ctrl+e | Hide completion menu |
| Insert: Ctrl+n / Ctrl+p | Next / previous completion |

The top completion is preselected. CoC provides completion previews and signatures. Sources include language servers, snippets, paths, and buffer text. The extension list is in `config/plugins.vim`; server options live in `coc-settings.json` (`:CocConfig`). CoC extension support can differ from Neovim LSP server options.

### Git

| Key | Action |
|---|---|
| `]h` / `[h` | Next / previous changed hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Undo hunk (discards that unstaged edit) |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Show blame for current line in Fugitive |
| `<leader>hB` | Toggle idle current-line blame in the message area |
| `<leader>hd` | Diff current file against index |

These work inside Git repositories. `:Git` opens Fugitive's status interface. Hunk staging changes the Git index but does not commit. Undo hunk changes your file; autosave may write it immediately.

### Terminal

| Key | Action |
|---|---|
| Ctrl+backslash / Alt+F12 | Toggle current terminal from editor or terminal |
| `<leader>t1` … `<leader>t4` | Toggle one of four independent shells |
| `<leader>ts` | Select a terminal session |
| `<leader>ta` | Hide all visible sessions, or show all existing sessions |
| `<leader>tf` | Toggle docked terminal (floating fallback) |
| Terminal: Esc Esc | Terminal Normal mode for selecting/scrolling output |
| Terminal: Ctrl+h/j/k/l | Move to adjacent editor window |

Each shell survives while hidden and reopens ready for input. The panel uses roughly 30% of the screen. Sessions are named Local, Local (2), and so on. Use `i` from Terminal Normal mode to resume input. The shell starts in the directory active when the session was created. `exit` ends the shell and closes its panel. Vim's native terminal escape prefix is Ctrl+w, so Ctrl+w followed by `N` is another way to enter Terminal Normal mode.

### Tasks and debugging

| Key | Action |
|---|---|
| `<leader>or` | Choose a build/run/test task |
| `<leader>ot` | Toggle task quickfix output |
| `<leader>dc` | Build C/C++ with debug symbols, launch on success |
| F5 | Start debugging or continue |
| F10 / F11 / F12 | Step over / into / out |
| `<leader>db` / `<leader>dB` | Toggle breakpoint / conditional breakpoint |
| `<leader>dr` | Debug console (REPL) |
| `<leader>dl` | Restart previous debug session |
| `<leader>dq` | Stop debug session and close debugger UI |
| `<leader>du` | Switch between debugger tab and previous tab |
| `<leader>dg` | Debug current Go file |
| `<leader>dj` | Java debug: Maven, then Gradle, then single file |
| `<leader>dJ` | Force Java single-file debugging |

## Running and building code

Open a source file, press `<leader>or`, enter its task number, and press Enter. Tasks save the current file first, run asynchronously, and populate quickfix after completion. Enter on a compiler diagnostic jumps to the location; `:cnext` and `:cprevious` navigate. `<leader>ot` hides/reopens output. `:VimTaskStop` stops a running task; only one task runs at a time. Output is collected while running and published when the job closes, rather than streamed into an Overseer panel.

| File / project | Available tasks |
|---|---|
| C++ | Build & run; build debug binary (`g++ -std=c++23 -g -O0 -Wall`) |
| C | Build & run; build debug binary (`cc -std=c17 -g -O0 -Wall`) |
| Go | Run current file; run package; test recursively; build recursively |
| Java | JDK source-file launch; compile & run |
| Gradle project | build; run; test |
| Maven project | package; test; compile exec:java |

C/C++ outputs an executable next to the source with its extension removed. `input.txt` next to the source takes precedence over `input.txt` in Vim's current working directory; the build/run task prints which it found. Without it the background task has no interactive stdin. For interactive input, run the compiled executable in a terminal session.

Go package execution uses the source directory. Recursive build/test searches upwards for `go.mod` or `.git`, falling back to Vim's current directory. Gradle and Maven search upward from the source for their build files or wrappers; project wrappers (`gradlew`, `mvnw`) take precedence and must be executable. Gradle `run` requires the application plugin; Maven `exec:java` requires an appropriate main-class configuration.

Compiled Java classes go into the state directory's `java-out`. The class name includes a simple detected package declaration; multi-module Java applications should use Gradle or Maven. File paths and command arguments are shell-escaped, including spaces and apostrophes.

## Debugging

### C / C++

Install a full Vim with `+python3` and `lldb-dap` (from LLVM or Xcode tools). The config checks `lldb-dap` on PATH, then `xcrun -f lldb-dap` on macOS. If neither resolves it, edit the `local-lldb` adapter in `config/debug.vim` to an absolute path.

1. Open the source file and set a breakpoint with `<leader>db`.
2. Press `<leader>dc` to build and debug. A failed build never launches the debugger.
3. Use F10/F11/F12 to step and `<leader>dr` for the debug console.
4. Press `<leader>dq` to terminate and reset the debugger tab.

F5 without an active session asks for an executable (defaults to the source path without extension). `input.txt` is passed through LLDB stdin settings when present. Debug sessions use Vim's current working directory, matching the original setup; change it with `:cd` when necessary.

### Go

Install Delve:

```sh
go install github.com/go-delve/delve/cmd/dlv@latest
```

Put `$(go env GOPATH)/bin` on PATH before starting Vim. `<leader>dg` starts current-file debugging using `dlv dap`. It also registers Go package and package-test configurations; use `:call vimspector#Launch()` to choose one after registration. The “Go test file” profile runs the file's package tests, since Delve test builds operate on packages. Set breakpoints and step with the same keys as C++.

### Java / Gradle / Maven

Uses the JDK's `jdb` in terminal splits, just like the source config. This is independent of Vimspector: use jdb commands rather than F5/step keys for Java.

- `<leader>dJ`: compile current file with `javac -g`, then start `jdb`; enter `run` when ready.
- `<leader>dj`: detect Maven first, then Gradle, otherwise debug the file.
- Maven starts suspended on port 8000 (`mvnDebug`, or a wrapper with `MAVEN_OPTS`). Gradle starts with `run --debug-jvm` on port 5005.
- A second terminal waits up to about 30 seconds with `nc` then attaches jdb. If startup takes longer, attach manually with `jdb -attach 8000` or `5005`.

| jdb command | Action |
|---|---|
| `stop at MyClass:42` | Break at a source line (use fully qualified class for packages) |
| `stop in MyClass.main` | Break on entering main |
| `run` | Start standalone program |
| `cont` / `next` / `step` | Continue / step over / step into |
| `step up` | Step out |
| `locals` / `print expression` | Inspect values |
| `exit` | Quit debugger |

The JVM launcher and jdb each own a terminal. Exit both when finished. Starting Maven/Gradle debugging requires the same project plugins/main-class settings as normal running.

## Plugins and equivalents

| Neovim component | Vim equivalent | Purpose |
|---|---|---|
| lazy.nvim | vim-plug | Explicit plugin installation and updates |
| Catppuccin nvim | Catppuccin Vim | Mocha colour scheme |
| nvim-tree + devicons | NERDTree + vim-devicons | File sidebar and icons |
| lualine / bufferline | vim-airline + tabline | Per-window status lines and buffer strip |
| Telescope | fzf.vim + fzf; CoC lists for symbols/diagnostics | Files, grep, history, buffers, code lists |
| blink.cmp / native LSP / Mason | coc.nvim extensions | Completion and language-server management |
| nvim-autopairs / surround | auto-pairs / vim-surround | Matching delimiters and surround editing |
| gitsigns | vim-gitgutter + vim-fugitive | Hunk actions, blame, diffs |
| conform.nvim | `config/format.vim` | CLI formatting and LSP fallback |
| toggleterm | `config/terminal.vim` | Persistent native terminal sessions |
| overseer | `config/tasks.vim` | Background builds and quickfix output |
| nvim-dap / dap-ui | Vimspector | Graphical debugger and console |
| alpha | `config/ui.vim` | Small dashboard: e/f/r/q |
| which-key | vim-which-key | Shortcut hints |
| indent-blankline | indentLine | Indentation guides |
| Treesitter | Native syntax + filetype indentation | Syntax highlighting and folding |
| nvim-notify | Vim messages | Notifications via `:messages` |

Surround examples: `ysiw"` wraps a word in quotes, `cs"'` changes double to single quotes, `ds"` deletes surrounding double quotes. Auto-pairs inserts closing brackets/quotes while typing. Vim surround's insert-mode mappings differ from nvim-surround; see `:help surround`.

Language extensions: `coc-clangd`, `coc-go`, `coc-java`, `coc-lua`, `coc-snippets`, plus `vim-snippets`. These replace Mason's server management rather than reusing the Neovim Mason directory. Use `:CocCommand` and extension-specific help to install/configure servers when prompted.

## File layout

```text
vim-config/
├── vimrc                    # Entry point; resolves its own path (including symlinks)
├── coc-settings.json        # CoC completion and server settings
├── config/
│   ├── options.vim          # Editor settings, state directories
│   ├── plugins.vim          # vim-plug declarations and plugin globals
│   ├── keymaps.vim          # Buffer, split, explorer mappings
│   ├── completion.vim       # Completion/LSP/snippet keys
│   ├── finder.vim           # fzf and live grep
│   ├── git.vim              # Git mappings and idle blame
│   ├── terminal.vim         # Four persistent native terminal sessions
│   ├── tasks.vim            # Project-aware asynchronous tasks
│   ├── debug.vim            # LLDB, Delve, jdb workflows
│   ├── format.vim           # Safe formatter pipeline
│   ├── ui.vim               # Theme, dashboard, which-key, health check
│   └── autocmds.vim         # Indentation, autosave, format-on-save
├── autoload/vimconfig.vim   # Project roots, wrappers, stdin, shell quoting
├── scripts/bootstrap.sh    # Install vim-plug; back up and install ~/.vimrc
├── scripts/validate.sh     # Isolated local smoke validation
├── tests/smoke.vim          # Behavioural checks without plugins/downloads
├── .github/workflows/validate.yml
├── CLAUDE.md               # Maintenance and changelog rules
├── VIMSCRIPT_HANDBOOK.md   # How to understand and customize the modules
└── README.md
```

To add a module, create `config/name.vim` and add `name` to the ordered list in `vimrc`. Options must precede plugin declarations and mappings. Change task definitions in `VimConfigTaskSpecs()`, not in the keymap file. Named augroups are cleared before redefinition so re-sourcing doesn't multiply those autocommands. Restart Vim after major plugin changes.

## External tools

Install only what your languages need. The configuration does not install system tools automatically.

| Tool | Used for | Setup note |
|---|---|---|
| Git, curl | Plugin bootstrap/installation | Must be on PATH |
| Node.js | CoC host and extensions | Use a current Node LTS supported by CoC |
| ripgrep (`rg`) | Live text search | `brew install ripgrep` |
| fzf | Fuzzy selection | `brew install fzf`, or plugin install hook |
| Go | Go run/build/test | `brew install go` |
| gopls | Go language intelligence | CoC Go extension management or `go install golang.org/x/tools/gopls@latest` |
| dlv | Go debugging | Install command in Debugging section |
| goimports | Go import formatting | `go install golang.org/x/tools/cmd/goimports@latest` |
| gofmt | Go formatting | Ships with Go |
| C/C++ compiler | Native tasks | Source uses C++23; compiler must support it |
| clangd | C/C++ language server | CoC clangd extension installation command or LLVM |
| clang-format | C/C++ formatting | Install LLVM/clang-format and expose on PATH |
| lldb-dap | Native debugging | LLVM or Xcode tools; check `xcrun -f lldb-dap` |
| JDK | Java, javac, jdb | Modern JDK; CoC Java's server may require a newer JDK than source-file launching |
| Gradle / Maven | Project builds | Prefer project wrappers; global binaries are fallbacks |
| nc | Wait for Java debug ports | Usually available on macOS; netcat on Linux |
| StyLua | Lua formatting | `cargo install stylua` if Rust is installed |
| Lua language server | Lua intelligence | CoC Lua extension / extension-specific setup |
| Python 3 + Vim python support | Vimspector | Python executable alone does not add `+python3` to Vim |

On macOS, Apple's `g++` can be Clang and may not accept all C++23 features. If needed install GCC and edit the compiler argv in `config/tasks.vim`. A project `.clangd` or `compile_commands.json` improves C/C++ diagnostics. Lua's `vim` global is allowed for compatibility with editing Neovim Lua files.

## Nerd Font

Set your terminal emulator's font to **JetBrainsMono Nerd Font** (or another Nerd Font) for file icons. Installing a font alone does not select it in Terminal/iTerm/your terminal preferences. For Homebrew users: `brew install --cask font-jetbrains-mono-nerd-font`. Restart or refresh the terminal's font picker afterward.

Icons are decorative; plain text remains usable. Remove the vim-devicons plugin if you prefer an icon-free setup.

## Differences from Neovim

Vim cannot load the original Lua plugins, so exact visual and internal parity is impossible. The custom shortcut names are retained, with these explicit adaptations:

| Area | Vim behaviour |
|---|---|
| Treesitter | Native syntax folding; some language syntax files offer fewer folds |
| Status/buffer bars | Airline per-window status lines; no global status line, slanted bufferline styling, or identical diagnostic badges |
| Terminal | Native docked splits, no ToggleTerm winbar strip or interactive floating windows; `<leader>tf` uses the dock |
| Tasks | One background task at a time; output shown on completion; quickfix replaces Overseer's task history/list |
| Code pickers | Symbols and diagnostics use CoC lists instead of Telescope |
| Completion | CoC popup previews/signatures; no promise of Blink's inline ghost-text UI |
| Debug UI | Vimspector tab instead of dap-ui panels; `<leader>du` switches tabs; UI may stay open after program exit until reset |
| Run last | `<leader>dl` restarts Vimspector's previous session |
| Go test file | Runs tests in the containing package |
| Blame toggle | Current-line blame appears on idle in the message area rather than inline virtual text |
| Notifications | Standard messages instead of animated notifications |
| Bootstrap | Explicit vim-plug bootstrap and PlugInstall, no automatic Rust/ripgrep installs |

Core editing keys, LSP keys (including the source's Neovim default `gr*` keys), Git hunk keys, task keys, terminal selectors, and debug function keys are preserved.

## Troubleshooting

| Symptom | Check / fix |
|---|---|
| Bootstrap download stays at 0 bytes | Press Ctrl+C to stop an older bootstrap. The updated script limits connection setup to 10 seconds and the whole download to 45 seconds, and stops a transfer after 15 seconds below 1 byte/second. Check GitHub access, VPN/proxy, and DNS, then rerun. Failed downloads leave vimrc and its backup untouched. |
| `PlugInstall` unknown | Run bootstrap; confirm `g:vim_config_data` matches its target |
| Plugin command unknown | Run `:PlugInstall`, inspect its errors, restart Vim |
| Completion unavailable | `:CocInfo`, `:CocList extensions`, `node --version`; inspect server errors |
| Code navigation unavailable | Check language server attached; open a project root; clangd needs compile flags for many projects |
| No colour/icons | Check terminal true colour and selected Nerd Font |
| No clipboard sharing | `:echo has('clipboard')`; use a full Vim build |
| Debug reports missing Python | `vim --version`; ensure shell resolves the full Vim build, not `/usr/bin/vim` |
| LLDB not found | `:VimConfigHealth`; check `xcrun -f lldb-dap` or set adapter absolute path |
| Delve not found | Put Go's bin directory on PATH before starting Vim |
| Java won't run | Check JAVA_HOME, JDK version, package/main class, and Gradle/Maven application settings |
| Java attach times out | Read suspended JVM terminal output; check ports 8000/5005 and `nc` |
| Task seems stuck | Background tasks cannot accept interactive stdin; use terminal or `input.txt`; stop with `:VimTaskStop` |
| Grep missing | Install `rg` and fzf; use `:pwd` to check search root |
| Alt/F-keys don't arrive | Configure terminal key forwarding; use Ctrl+backslash as terminal fallback and Fn for function keys |
| File saved unexpectedly | Autosave is enabled by design; remove its autocmd in `config/autocmds.vim` to disable |
| Formatting pauses | CLI formatting is synchronous; remove BufWritePre hook or use `:VimFormat` manually |
| Persistent state permission errors | Check `g:vim_config_state` points to a writable directory |

Useful commands: `:messages`, `:scriptnames`, `:verbose nmap <leader>ff`, `:CocInfo`, `:CocConfig`, `:PlugStatus`, `:VimConfigHealth`. Plugin upgrades: `:PlugUpdate`; CoC extension upgrades: `:CocUpdate`. Restart after updates.

## Validation

```sh
sh ~/Desktop/vim-config/scripts/validate.sh
```

The script runs Vim without user config/viminfo, uses temporary state, and checks source loading, mapped keys, indentation exceptions, root detection, input-file lookup, autosave, shell quoting, and async task success/failure with quickfix. It does not download plugins or require compilers. CI runs the same checks on Ubuntu. External language servers, real debugger adapters, and terminal-emulator key delivery need testing on the machine where you use the configuration.

## Reference documentation

Plugin integration follows the maintainers' documentation: [CoC](https://github.com/neoclide/coc.nvim), [fzf.vim](https://github.com/junegunn/fzf.vim), [Vimspector configuration](https://puremourning.github.io/vimspector/configuration.html), [vim-gitgutter](https://github.com/airblade/vim-gitgutter), and [Catppuccin Vim](https://github.com/catppuccin/vim). These links are also useful when plugin versions evolve.

## Changelog

### 2026-10-27 — Dashboard startup fix

- Fixed `E121: Undefined variable: Bar` on VimEnter by using Ex command separators in the dashboard autocommand; `<Bar>` belongs in mapping definitions.
- Added regression coverage that executes VimEnter with the dashboard enabled and disabled, and verifies the dashboard opens correctly.


### 2026-10-27 — Bounded bootstrap download

- Added a progress notice, 10-second connection timeout, 45-second total download timeout, and low-speed timeout for stalled GitHub downloads.
- Failed or empty downloads now stop with an actionable message before changing vimrc or its backup; temporary downloads are cleaned up.


### 2026-10-27 — Default vimrc installation

- Bootstrap now copies the entry point to `~/.vimrc`, moves the existing file to `~/.vimrc.old`, and removes an older backup before replacing it.
- Pinned the copied entry point to its source module directory so the modular configuration still loads from the default vimrc location.
- Bootstrap continues with vimrc installation when vim-plug is already present; updated setup and backup instructions.

### 2026-10-27

- Ported the modular Neovim setup to native Vimscript with matching editor settings and shortcut families.
- Added Vim-compatible completion, navigation, Git, search, theme, explorer, buffer strip, shortcut hints, and editing plugins.
- Added persistent native terminals, project-aware async build/test tasks, LLDB/Delve debug configuration, and standalone/project jdb workflows.
- Added guarded autosave, formatter pipelines, explicit bootstrap, health checks, isolated smoke validation, and CI.
- Documented installation, all shortcuts, dependencies, workflows, maintenance, and Vim-specific differences; included a Vimscript handbook.
