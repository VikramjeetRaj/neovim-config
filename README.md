# Neovim Configuration — Guide

This is the complete guide to this Neovim setup. It's written so that **anyone can follow it**, even if you've never used Neovim or written code. Every technical word is explained in the [Key terms](#key-terms-plain-english-glossary) section, and there's a plain-English [cheat sheet](#quick-reference-how-do-i-do-x) if you just want to get something done quickly.

> **Tip:** To search this document, open it in any Markdown viewer or text editor and press `Ctrl+F` (or `Cmd+F` on Mac), then type what you're looking for — e.g. "search files", "breakpoint", "font", "close buffer".

---

## Contents

1. [What is this?](#what-is-this)
2. [Key terms (plain-English glossary)](#key-terms-plain-english-glossary)
3. [How to read the shortcuts](#how-to-read-the-shortcuts)
4. [Quick reference: how do I do X?](#quick-reference-how-do-i-do-x)
5. [First-time setup](#first-time-setup)
6. [Editor behaviour (settings)](#editor-behaviour-settings)
7. [Keyboard shortcuts (full list)](#keyboard-shortcuts-full-list)
8. [Running and building code (tasks)](#running-and-building-code-tasks)
9. [Debugging: how to use](#debugging-how-to-use)
10. [Plugins and what each one does](#plugins-and-what-each-one-does)
11. [How the configuration is organised (file layout)](#how-the-configuration-is-organised-file-layout)
12. [External tools you need to install](#external-tools-you-need-to-install)
13. [Nerd Font (JetBrains Mono)](#nerd-font-jetbrains-mono)
14. [Troubleshooting](#troubleshooting)

---

## What is this?

**Neovim** is a text editor for writing code — think of it like Notepad or Microsoft Word, but built for programmers and controlled mostly with the keyboard instead of the mouse.

By itself Neovim is fairly bare. This configuration file (`init.lua`) adds a set of **plugins** (add-ons) that turn it into a full coding environment for four programming languages: **Go, Java, C/C++, and Lua**. It gives you:

- A colourful, modern look (the *Catppuccin* theme).
- A **file explorer** sidebar, **tabs** for open files, and a **status bar**.
- **Autocomplete** and smart code features (jump to definitions, rename, see errors) powered by *language servers*.
- **Debugging** — run your program step by step to find bugs.
- A **task runner** to build and run your programs with one shortcut.
- A **fuzzy finder** to jump to any file or search all your text instantly.
- **Git** integration to see and manage your code changes.

You do **not** need to understand the `init.lua` file to use any of this. This guide covers everything you need.

**Requirements:** Neovim version **0.11 or newer**, and a [Nerd Font](#nerd-font-jetbrains-mono) so icons display correctly.

---

## Key terms (plain-English glossary)

If a word in this guide is unfamiliar, look it up here.

| Term | What it means |
|---|---|
| **Normal mode** | The default state in Neovim where keys are commands (not typing). Press `Esc` to get here. |
| **Insert mode** | Where you actually type text, like a normal editor. Press `i` to enter it, `Esc` to leave. |
| **Leader key** | A "prefix" key you press before a shortcut. In this setup it's the **backslash `\`** key (see the note in [shortcuts](#how-to-read-the-shortcuts)). |
| **Buffer** | An open file. Having "3 buffers open" means 3 files are open. |
| **Window / split** | A pane on screen. You can split the screen to view two files side by side. |
| **Status line** | The info bar at the bottom showing the file name, position, and errors. |
| **File tree / explorer** | A sidebar listing your project's files and folders. |
| **Gutter** | The narrow strip on the far left, where line numbers and small symbols (errors, git marks) appear. |
| **LSP (Language Server)** | A background helper that understands your code — it powers autocomplete, error checking, and "jump to definition". |
| **Autocomplete** | The pop-up list of suggestions as you type. |
| **Diagnostic** | An error or warning about your code, shown in the gutter and underlined. |
| **Definition / declaration** | The place in the code where a function or variable was created. "Jump to definition" takes you there. |
| **Debugging** | Running your program in slow motion so you can pause it and inspect what's happening. |
| **Breakpoint** | A marker on a line that tells the debugger "pause here". |
| **Step over / into / out** | While paused: run the next line / go inside a function call / finish the current function. |
| **REPL** | A prompt where you can type expressions and see their value while debugging. |
| **Task / task runner** | A saved command (like "build this program") you trigger with a shortcut instead of typing it. |
| **Fuzzy finder** | A fast search box: type a few letters and it finds matching files or text. |
| **Hunk (git)** | A single block of changed lines in a file. |
| **Stage (git)** | Marking a change as ready to be saved into git history. |
| **Blame (git)** | Showing who last changed a line and when. |
| **Formatter** | A tool that automatically tidies your code's spacing and layout when you save. |
| **Nerd Font** | A special font containing extra icon symbols. Without it, icons show as boxes or question marks. |
| **PATH** | The list of folders your computer searches for installed programs. A tool "on your PATH" can be run from anywhere. |
| **Homebrew (`brew`)** | A popular app installer for Mac, used in the install commands below. |

---

## How to read the shortcuts

Shortcuts are written using a few conventions:

| Notation | Means | Example |
|---|---|---|
| `<leader>` | Your **leader key** — the **backslash `\`** in this setup | `<leader>e` = press `\` then `e` |
| `<C-x>` | Hold **Ctrl** and press `x` | `<C-\>` = hold Ctrl, press backslash |
| `<S-x>` | Hold **Shift** and press `x` (a capital letter) | `<S-l>` = Shift + L |
| `<F5>` | The **F5** function key at the top of the keyboard | |
| `<CR>` | The **Enter / Return** key | |

**How to type a shortcut like `<leader>ff`:** make sure you're in **Normal mode** (press `Esc` first if unsure), then press the keys in order — `\`, then `f`, then `f` — reasonably quickly.

> **About the leader key:** this config uses the default leader, which is the **backslash `\`**. Many people prefer the **Spacebar**. To switch, add this line to `lua/config/options.lua`: `vim.g.mapleader = " "`. After that, every `<leader>` shortcut below is triggered with Space instead of backslash.

> **Helpful:** if you press the leader key and pause, a **pop-up menu** (which-key) appears showing every shortcut available next. You don't have to memorise anything.

---

## Quick reference: how do I do X?

The most common things you'll want, in plain English. Full lists are further down.

| I want to… | Press | 
|---|---|
| Open a file by typing its name | `<leader>ff` |
| Search for some text across all files | `<leader>fg` |
| Reopen a file I had open recently | `<leader>fr` |
| Show or hide the file explorer sidebar | `<leader>e` |
| Go to the next / previous open file | `<S-l>` / `<S-h>` |
| Close the current file | `<leader>x` |
| Move between side-by-side windows | `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` |
| Split the screen vertically / horizontally | `<leader>sv` / `<leader>sh` |
| Open / close the bottom terminal | `<C-\>` or `<A-F12>` |
| See documentation for the thing under my cursor | `K` |
| Jump to where a function/variable is defined | `gd` |
| Rename a variable everywhere it's used | `<leader>rn` |
| See suggested fixes for an error | `<leader>ca` |
| Read the error message on this line | `<leader>ld` |
| Jump to the next / previous error | `]d` / `[d` |
| Run or build my program | `<leader>or`, then pick a task |
| Start debugging my program | set a breakpoint with `<leader>db`, then `<F5>` |
| See who last changed this line (git) | `<leader>hb` |
| Save a change into git (stage it) | `<leader>hs` |

---

## First-time setup

Do this once, in order:

1. **Install a [Nerd Font](#nerd-font-jetbrains-mono)** and set it as your terminal's font (instructions at the bottom). Without this, icons look broken.
2. **Install the [external tools](#external-tools-you-need-to-install)** for the languages you'll use (for example the Go toolchain, or a Java JDK). You can skip the ones you don't need.
3. **Open Neovim** by running `nvim` in your terminal. The first launch automatically downloads and installs all the plugins — give it a minute.
4. Type `:Lazy sync` and press Enter to make sure every plugin finished installing. Then type `:Mason` and press Enter to confirm the code helpers (`gopls`, `clangd`, `jdtls`, `lua_ls`) are installed.
5. Type `:checkhealth` and press Enter to run a self-test and spot anything missing.

> Commands that start with `:` are typed in Normal mode; a command line appears at the bottom. Press Enter to run, `Esc` to cancel.

---

## Editor behaviour (settings)

These are on automatically — no shortcuts needed. Listed so you know why the editor behaves the way it does.

| Setting | What you'll notice |
|---|---|
| Line numbers (absolute) | Each line shows its real line number down the left |
| Always-visible gutter | The left strip never jumps around when errors or git marks appear |
| Cursor line highlight | The line you're on is subtly highlighted |
| No line wrapping | Long lines run off-screen instead of wrapping |
| Smart-case search | Searching is case-insensitive unless you type a capital letter |
| Persistent undo | You can undo changes **even after closing and reopening** a file |
| 8-space indentation (JetBrains-style) | Tab inserts 8 spaces; pressing Enter carries the current indent onto the next line, and Tab/Backspace move a whole 8-space step at a time (switches to real tabs automatically for Go and Makefiles, which require them) |
| System clipboard shared | Copy in Neovim, paste in other apps, and vice-versa |
| Mouse off | The editor is keyboard-only by design |
| Code folding | You can collapse blocks of code (via Treesitter); everything starts expanded |
| **Autosave** | Your file saves itself when you leave insert mode, change text, or switch away — like an IDE |
| **Format on save** | Code is automatically tidied every time it saves — the formatters use an 8-space indent to match the editor, so saving never rewrites your indentation width |

---

## Keyboard shortcuts (full list)

Grouped by what you're doing. Some shortcuts (marked *code* or *git*) only work while you're in a relevant file.

### Moving between open files (buffers)

| Key | Action |
|---|---|
| `<S-l>` | Go to the next open file |
| `<S-h>` | Go to the previous open file |
| `<leader>x` | Close the current file |

### Moving between windows (splits)

A "window" is one pane on screen. You can show several files side by side by splitting, then hop between them without the mouse.

| Key | Action |
|---|---|
| `<C-h>` | Move to the window on the left |
| `<C-j>` | Move to the window below |
| `<C-k>` | Move to the window above |
| `<C-l>` | Move to the window on the right |
| `<leader>sv` | Split the current window vertically (side by side) |
| `<leader>sh` | Split the current window horizontally (top / bottom) |
| `<leader>se` | Make all windows equal size |
| `<leader>sc` | Close the current window |
| `<leader>so` | Close every window except the current one |
| `<C-Up>` / `<C-Down>` | Make the window taller / shorter |
| `<C-Left>` / `<C-Right>` | Make the window narrower / wider |

### File explorer

| Key | Action |
|---|---|
| `<leader>e` | Show / hide the file tree sidebar |

### Search and find things (fuzzy finder)

| Key | Action |
|---|---|
| `<leader>ff` | Find a file by name |
| `<leader>fg` | Search for text across all files |
| `<leader>fw` | Search for the word currently under the cursor |
| `<leader>fb` | Switch between currently open files |
| `<leader>fr` | Reopen a recently used file |
| `<leader>fh` | Search Neovim's built-in help |
| `<leader>fs` | List all functions/variables in the current file |
| `<leader>fd` | List all errors/warnings in the project |

### Understanding and editing code (LSP) — *code*

Works when a language server is running for the file. Neovim also has these built in: `grr` (find where something is used), `grn` (rename), `gra` (quick fixes), `gri` (go to implementation), `gO` (list symbols), `K` (documentation).

| Key | Action |
|---|---|
| `gd` | Jump to where this is **defined** |
| `gD` | Jump to where this is **declared** |
| `K` | Show documentation for the item under the cursor |
| `grr` | Show everywhere this item is used |
| `gri` | Jump to its implementation |
| `<leader>rn` | Rename this item everywhere |
| `<leader>ca` | Show available fixes / actions |
| `<leader>ld` | Read the full error message on this line |
| `[d` | Go to the previous error/warning |
| `]d` | Go to the next error/warning |

### Autocomplete pop-up — *while typing*

The suggestion list pops up automatically as you type, with the top item
previewed inline as faint "ghost text".

| Key | Action |
|---|---|
| `Tab` or `Enter` | Accept the highlighted suggestion |
| `Tab` | Also jumps between fields inside a snippet |
| `<C-Space>` | Open / toggle the suggestion list |
| `<C-e>` | Close the suggestion list |
| `<C-n>` / `<C-p>` | Move down / up the list |

> Prefer `<C-y>`-only acceptance instead of Tab/Enter? In `lua/plugins/completion.lua`, change `keymap = { preset = "super-tab", ... }` back to `preset = "default"`.

### Git changes — *git*

Works inside a file that's in a git repository.

| Key | Action |
|---|---|
| `]h` | Jump to the next changed block (hunk) |
| `[h` | Jump to the previous changed block |
| `<leader>hs` | Stage this change (mark it ready to commit) |
| `<leader>hr` | Undo this change back to the last saved git version |
| `<leader>hp` | Preview what changed in this block |
| `<leader>hb` | Show who last changed this line, with details |
| `<leader>hB` | Turn the always-on line author display on/off |
| `<leader>hd` | Show all changes in the current file |

### Debugging (C, C++, Go)

See [Debugging: how to use](#debugging-how-to-use) for step-by-step instructions.

| Key | Action |
|---|---|
| `<F5>` | Start debugging, or continue to the next breakpoint |
| `<F10>` | Step over (run the next line) |
| `<F11>` | Step into (go inside the function call) |
| `<F12>` | Step out (finish the current function) |
| `<leader>db` | Add or remove a breakpoint on this line |
| `<leader>dB` | Add a breakpoint that only triggers under a condition |
| `<leader>dr` | Open the debug prompt (REPL) |
| `<leader>dl` | Re-run the last debug session |
| `<leader>dq` | Stop debugging and close the debug panels |
| `<leader>du` | Show / hide the debug panels |
| `<leader>dc` | **C++ only**: compile, then start debugging automatically |
| `<leader>dg` | **Go only**: debug the current file |

### Debugging (Java)

Java uses `jdb`, a text-based debugger that opens in a terminal.

| Key | Action |
|---|---|
| `<leader>dj` | Debug — automatically detects Maven, Gradle, or a single file |
| `<leader>dJ` | Debug the current single `.java` file |

### Running and building (task runner)

| Key | Action |
|---|---|
| `<leader>or` | Open the list of run/build tasks and pick one |
| `<leader>ot` | Show / hide the task output panel |

### Terminal

| Key | Action |
|---|---|
| `<C-\>` / `<A-F12>` | Show / hide the terminal docked at the bottom (works from inside it too; the shell keeps running while hidden) |
| `<leader>t1` … `<leader>t4` | Open terminal 1–4 — each is its own shell, shown as a tab ("Local", "Local (2)") along the top of the panel; click a tab to switch |
| `<leader>tf` | Open a floating terminal instead |
| `<leader>ta` | Show / hide all terminals |
| `<leader>ts` | Pick a terminal from a list |
| `<Esc><Esc>` | (inside a terminal) go to normal mode so you can scroll / copy |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | (inside a terminal) jump to the neighbouring window |

> `<A-F12>` is `Option+F12` on macOS (IntelliJ's terminal shortcut). It works in Neovide; in Terminal.app / iTerm2 you may need to set Option to act as Alt/Esc+, otherwise use `<C-\>`.

---

## Running and building code (tasks)

Press `<leader>or` to open a menu of ready-made commands ("tasks"). The menu only shows tasks that make sense for the file or project you're in, so you won't be overwhelmed. Pick one and it runs; press `<leader>ot` to see its output.

| Task | Shows up when | What it does |
|---|---|---|
| C++ build & run | editing a `.cpp` file | Compiles the file and runs it. If an `input.txt` exists next to the source **or** in the working directory, it's fed to the program's `cin`; the output shows which file was used (or that none was found). Runs with no input if there isn't one |
| C++ build (debug) | editing a `.cpp` file | Compiles with debug info (used by the debugger) |
| Go run (file) | editing a `.go` file | Runs just this file |
| Go run (package) | editing a `.go` file | Runs the whole folder as a program |
| Go test (package) | editing a `.go` file | Runs the project's tests |
| Go build | editing a `.go` file | Compiles the whole project |
| Java run (single file) | editing a `.java` file | Runs a single Java file directly (Java 11+) |
| Java compile & run | editing a `.java` file | Compiles then runs the file |
| Gradle build / run / test | project has a `build.gradle` | Runs the matching Gradle command |
| Maven package / test / run | project has a `pom.xml` | Runs the matching Maven command |

For Gradle and Maven, if the project includes a wrapper script (`gradlew` or `mvnw`) it's used automatically; otherwise the globally installed `gradle`/`mvn` is used.

---

## Debugging: how to use

**Debugging** lets you pause your running program and look inside it to find bugs. The general idea is the same everywhere: put a **breakpoint** on a line, start the program, and it pauses there so you can look around and step through line by line.

For **C/C++** and **Go**, a set of debug panels (showing variables, the call stack, and breakpoints) **opens automatically** when you start, and closes when you stop. **Java** is different — it uses a text prompt in a terminal.

### C / C++

1. Open a `.c` or `.cpp` file. Put your cursor on a line and press `<leader>db` to set a breakpoint (a red dot appears in the gutter).
2. Start it one of two ways:
   - **Recommended:** `<leader>dc` — it compiles a debug build for you, then starts the debugger automatically.
   - `<F5>` — choose the *Launch* option; you'll be asked for the path to an already-compiled program (it suggests the current file's name without its extension).
3. When it pauses at your breakpoint, step through with `<F10>` (next line), `<F11>` (go into a function), `<F12>` (finish the function). Watch the variables in the panels, or type expressions at the prompt with `<leader>dr`.
4. Press `<leader>dq` to stop and close everything. `<leader>du` shows/hides the panels manually.

> **Feeding input while debugging:** just like the run task, if an `input.txt` sits next to your source file (or in the working directory), it's fed to the program's `cin` during a debug session, so you don't have to type input by hand. This relies on your `lldb-dap` version supporting stdin redirection — if input isn't picked up, see the note in the changelog.

### Go

1. Open a `.go` file and set a breakpoint with `<leader>db`.
2. Start debugging:
   - `<leader>dg` — quickly debug the current file.
   - `<F5>` — pick from four options: debug the current file, the whole package (folder), the current test file, or the package's tests.
3. Go compiles and runs automatically — there's no separate build step. Step through and inspect exactly as with C/C++, and stop with `<leader>dq`.

> Go debugging needs the **Delve** tool (`dlv`) installed — see [external tools](#external-tools-you-need-to-install).

### Java

1. Press `<leader>dj`. It figures out your project automatically: a Maven project, a Gradle project, or a single file. (`<leader>dJ` forces single-file mode.)
2. What happens:
   - **Single file:** it compiles your file and drops you into the `jdb` prompt.
   - **Maven/Gradle project:** it opens two terminal panes — your program (paused, waiting) and the `jdb` debugger attaching to it.
3. Control it by typing commands at the `jdb` prompt:

| Type this | To do this |
|---|---|
| `stop at MyClass:42` | Set a breakpoint at line 42 |
| `stop in MyClass.main` | Break when a method is entered |
| `run` | Start the program (single-file mode) |
| `cont` | Continue running (attach mode) |
| `step` | Run the next line, going into functions |
| `next` | Run the next line, skipping over functions |
| `locals` | Show the current local variables |
| `print x` | Show the value of `x` |
| `exit` | Quit the debugger |

---

## Plugins and what each one does

Plugins are the add-ons that provide all the features above. You don't install these by hand — they download automatically. Listed here so you know what each is responsible for.

| Plugin | What it provides |
|---|---|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | The plugin manager — installs and updates everything else |
| [catppuccin/nvim](https://github.com/catppuccin/nvim) | The colour theme (Mocha) |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | The status bar at the bottom |
| [alpha-nvim](https://github.com/goolord/alpha-nvim) | The welcome screen shown when you open Neovim |
| [nvim-notify](https://github.com/rcarriga/nvim-notify) | Nice pop-up notifications |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | The tabs for open files across the top — slanted tabs with colored filetype icons, close buttons, and inline error/warning badges |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Accurate syntax colouring and code folding (its experimental auto-indent is disabled; Neovim's built-in indenters handle indentation) |
| [nvim-dap](https://github.com/mfussenegger/nvim-dap) | The core debugger engine |
| [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) | The debugger panels (variables, call stack, breakpoints) |
| [nvim-nio](https://github.com/nvim-neotest/nvim-nio) | A helper library the debugger UI needs |
| [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) | The file explorer sidebar |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | The file-type icons (needs a Nerd Font) |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | Connects Neovim to the language servers |
| [mason.nvim](https://github.com/mason-org/mason.nvim) | Installs the language servers and tools for you |
| [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim) | Links Mason and lspconfig together automatically |
| [blink.cmp](https://github.com/saghen/blink.cmp) | The autocomplete pop-up |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | The fuzzy finder (find files, search text) |
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | A helper library Telescope needs |
| [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim) | Makes the fuzzy finder much faster |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git marks in the gutter, blame, staging |
| [overseer.nvim](https://github.com/stevearc/overseer.nvim) | The task runner (build/run/test) |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Auto-formats your code on save |
| [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) | The IntelliJ-style bottom terminal panel |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | The pop-up that shows available shortcuts as you type |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Auto-closes brackets and quotes |
| [nvim-surround](https://github.com/kylechui/nvim-surround) | Quickly add/change/remove quotes or brackets around text |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Faint vertical lines showing indentation |

**Code tidiers used on save:** `clang-format` (C/C++), `goimports` + `gofmt` (Go), `stylua` (Lua). `clang-format` and `stylua` are set to an 8-space indent to match the editor; Go keeps its conventional tabs.

**Language helpers installed automatically by Mason:** `lua_ls` (Lua), `gopls` (Go), `clangd` (C/C++), `jdtls` (Java).

---

## How the configuration is organised (file layout)

The config used to live in one large `init.lua`. It's now split into small, single-purpose files so each piece is easy to find and edit. You don't need to understand any of this to *use* the editor — it only matters if you want to change something.

`init.lua` is now tiny: it bootstraps the plugin manager, loads the three core-settings files, then automatically loads every file in `lua/plugins/`.

```
~/.config/nvim/
├── init.lua                     Entry point: bootstrap + load everything below
├── lua/
│   ├── config/                  Your personal settings (not plugins)
│   │   ├── options.lua          Editor behaviour (line numbers, indenting, autosave timing, …)
│   │   ├── keymaps.lua          General shortcuts (buffer switching, close buffer)
│   │   ├── autocmds.lua         Automatic actions (autosave, tabs-vs-spaces per language)
│   │   ├── util.lua             Small shared helper functions used by the two files below
│   │   ├── overseer_tasks.lua   All the build / run / test task definitions (the task runner)
│   │   └── dap_config.lua       Go and Java debugger setup
│   └── plugins/                 One file per plugin (or group); loaded automatically
│       ├── colorscheme.lua      Catppuccin theme
│       ├── ui.lua               Status bar, tabs, welcome screen, notifications, which-key, indent guides
│       ├── treesitter.lua       Syntax colouring / folding
│       ├── explorer.lua         File-tree sidebar
│       ├── telescope.lua        Fuzzy finder
│       ├── lsp.lua              Language servers (Mason + lspconfig)
│       ├── completion.lua       Autocomplete pop-up (blink.cmp)
│       ├── dap.lua             Debugger engine + UI, and C/C++ debugging
│       ├── overseer.lua         Task-runner plugin (loads the tasks from config/overseer_tasks.lua)
│       ├── conform.lua          Format-on-save
│       ├── gitsigns.lua         Git marks, blame, staging
│       ├── toggleterm.lua       Bottom terminal panel (IntelliJ-style)
│       └── editing.lua          Auto-pairs and surround
```

**Where do I change X?**

| I want to change… | Edit this file |
|---|---|
| A setting like indentation, line numbers, or autosave | `lua/config/options.lua` |
| A general shortcut (e.g. how to switch or close files) | `lua/config/keymaps.lua` |
| Autosave / format-on-save behaviour rules | `lua/config/autocmds.lua` |
| A build/run/test task, or add a new one | `lua/config/overseer_tasks.lua` |
| How Go or Java debugging launches | `lua/config/dap_config.lua` |
| A specific plugin's options | the matching file in `lua/plugins/` |
| Add a brand-new plugin | create a new file in `lua/plugins/` that returns its spec |

> **Adding a new plugin:** drop a file like `lua/plugins/myplugin.lua` that `return`s a lazy.nvim spec table. It's picked up automatically — no need to edit `init.lua`.

---

## External tools you need to install

These are separate programs Neovim uses but does **not** install itself. Install only the ones for the languages you use. On a Mac, most are installed with **Homebrew** (`brew`). If you don't have Homebrew, get it from <https://brew.sh>.

| Tool | Needed for | Install command (Mac) |
|---|---|---|
| Git | Downloading plugins, git features | `xcode-select --install` or `brew install git` |
| A Nerd Font | Icons everywhere | [See the next section](#nerd-font-jetbrains-mono) |
| Xcode Command Line Tools | C/C++ debugging + some builds | `xcode-select --install` |
| `g++` / `clang++` | Compiling C++ | Comes with Xcode tools (or `brew install gcc`) |
| Go | Running/building Go | `brew install go` |
| Delve (`dlv`) | **Debugging** Go | `brew install delve` |
| Java (JDK 17+) | Running/debugging Java | `brew install openjdk` |
| Maven | Java Maven projects | `brew install maven` |
| Gradle | Java Gradle projects | `brew install gradle` |
| `clang-format` | Auto-formatting C/C++ | `brew install clang-format` |
| `stylua` | Auto-formatting Lua | `brew install stylua` |
| Node.js *(optional)* | Some language tools | `brew install node` |
| ripgrep (`rg`) | Fuzzy-finder search (`<leader>fg`, live grep) | Installed automatically by `init.lua` on first launch (via rustup + `cargo install ripgrep`) if missing — no action needed, but `brew install ripgrep` is faster if you'd rather install it yourself first |

> After installing, you may need to open a **new terminal window** for the tool to be found. To check a tool is installed, type its name and `--version` (for example `go version` or `java -version`).

---

## Nerd Font (JetBrains Mono)

Many things in this setup (file icons, the status bar, tabs) use special icon symbols. These only display correctly with a **Nerd Font** installed. Without one, you'll see empty boxes or question marks where icons should be. This config is set up for **JetBrains Mono Nerd Font**.

**Download it:**

- Direct download (zip): <https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip>
- Browse all Nerd Fonts: <https://github.com/ryanoasis/nerd-fonts/releases>

**Install it manually on a Mac:**

1. Download and unzip `JetBrainsMono.zip` (double-click the downloaded file to unzip it).
2. Open the unzipped folder, select all the `.ttf` font files, then **right-click → Open** and click **Install Font** in the window that appears. (This adds them to Font Book, Mac's font manager.)

   *Prefer the terminal? Run:*
   ```sh
   unzip ~/Downloads/JetBrainsMono.zip -d ~/Downloads/JetBrainsMono
   cp ~/Downloads/JetBrainsMono/*.ttf ~/Library/Fonts/
   ```
3. Tell your terminal to use the new font:
   - **Apple Terminal:** Settings → Profiles → Text → Font → choose *JetBrainsMono Nerd Font*
   - **iTerm2:** Settings → Profiles → Text → Font → choose *JetBrainsMono Nerd Font*
   - **Ghostty:** add `font-family = "JetBrainsMono Nerd Font"` to its config file
   - **WezTerm / Kitty:** set the font family in their config files
4. Fully quit and reopen the terminal, then start Neovim again.

**Easiest option (with Homebrew):**
```sh
brew install --cask font-jetbrains-mono-nerd-font
```
Then just set your terminal font as in step 3.

**Check it worked:** run this in your terminal —
```sh
echo -e "  "
```
If you see small icons (a house and folders) instead of boxes or question marks, the font is working.

---

## Troubleshooting

| Problem | Likely fix |
|---|---|
| Icons show as boxes or `?` | The Nerd Font isn't installed or isn't selected as your terminal font — see the section above |
| A shortcut does nothing | Make sure you're in **Normal mode** (press `Esc`), and remember `<leader>` is the **backslash `\`** key |
| Autocomplete / errors not working in a file | The language server may still be installing — check with `:Mason`, and run `:checkhealth` |
| "command not found" when running/debugging | The language's [external tool](#external-tools-you-need-to-install) isn't installed or isn't on your PATH — open a new terminal after installing |
| Go debugging won't start | Install Delve: `brew install delve` |
| Plugins look broken after an update | Run `:Lazy sync`, then restart Neovim |
| I forget the shortcuts | Press the leader key (`\`) and wait — a menu of options pops up |

---

## Changelog

All changes to this configuration are logged here, newest first.

### 2026-10-01 (auto-install ripgrep)
- `init.lua` now checks for `rg` on startup and, if missing, blocking-installs
  it: runs the official rustup script (`curl ... | sh -s -- -y`) to get
  `cargo` if needed, then `cargo install ripgrep`. Errors are reported via
  `vim.notify` instead of failing silently. This runs synchronously, so the
  very first launch without `rg` or `cargo` installed will pause for a couple
  of minutes while the rustup install and `cargo install ripgrep` build
  complete; subsequent launches skip it once `rg` is found.
- Added a row for ripgrep to the "External tools you need to install" table.

### 2026-09-25 (IntelliJ-style terminal)
- Reworked `lua/plugins/toggleterm.lua` so the terminal behaves like IntelliJ's
  Terminal tool window: it now docks at the bottom (`direction = "horizontal"`,
  ~30% of the screen) instead of floating, and shows a tab strip ("Local",
  "Local (2)", ...) via toggleterm's `winbar`.
- Added `<A-F12>` (IntelliJ's shortcut) alongside the existing `<C-\>` toggle,
  `<leader>t1`..`<leader>t4` for separate shell sessions, `<leader>tf` for a
  floating terminal, `<leader>ta` toggle-all and `<leader>ts` picker.
- Inside a terminal: `<Esc><Esc>` returns to normal mode and `<C-h/j/k/l>` move
  between windows. Terminal buffers are already skipped by autosave.
- Updated the Terminal shortcuts table, Quick-reference row, plugin table and
  file-layout entry in this README.

### 2026-07-26 (input.txt stdin for C++ debug)
- Extended the `input.txt` stdin convention to C++ debugging. Added
  `find_input_txt()` and `lldb_stdin_fields()` helpers in `lua/config/util.lua`,
  and wired them into both debug entry points: the `<F5>` *Launch* config in
  `lua/plugins/dap.lua` and the `<leader>dc` build-and-debug flow in
  `lua/config/overseer_tasks.lua`. When an `input.txt` exists next to the source
  or in the cwd, it's fed to the debugged program's stdin.
- Because lldb-dap's stdin redirection differs by version, both mechanisms are
  set: `stdio` (lldb-dap >= 22.0) and a `settings set target.input-path ...`
  `preRunCommand` (older lldb-dap, e.g. the one from Xcode via `xcrun -f
  lldb-dap`). Verified the lldb-dap config keys against the official README; the
  `stdio` key is documented as added in v22.0, which is why the `target.input-path`
  fallback is included. Go (delve) and Java (jdb, interactive terminal) were left
  as-is since their stdin models differ. If input still isn't read while
  debugging, check `lldb-dap --version`; the fallback covers older versions but
  behavior can vary.

### 2026-07-26 (merge C++ run tasks)
- Folded the `input.txt` stdin handling into the main `C++ build & run` task and
  removed the separate `C++ build & run (input.txt)` template in
  `lua/config/overseer_tasks.lua`. Having two near-identical entries meant the
  plain one (no stdin redirection) was easy to pick by mistake. Now there's a
  single task that always checks for `input.txt` (next to the source or in the
  cwd) and prints which file it used. Note: task templates register when Overseer
  loads, so restart Neovim after this change for it to take effect.

### 2026-07-26 (fix C++ input.txt not read)
- The `C++ build & run (input.txt)` task only checked for `input.txt` next to the
  source file, so an `input.txt` kept in the project root / cwd was silently
  ignored. Updated `lua/config/overseer_tasks.lua` to set the task `cwd` to the
  source folder, look for `input.txt` both next to the source and in the cwd, and
  print a visible `[stdin: ...]` / `[no input.txt found ...]` notice so it's never
  silent. Verified the shell redirection reads the file correctly.

### 2026-07-26 (fix indent-on-Enter)
- Disabled Treesitter `indent` in `lua/plugins/treesitter.lua`. It sets
  `indentexpr`, which overrides `autoindent`/`smartindent` and was preventing the
  indent from carrying onto the next line when pressing Enter. With it off,
  Neovim's built-in indenters (e.g. C/C++ `cindent`) handle indentation
  reliably. Highlighting and folding are unaffected.

### 2026-07-26 (formatter indent width)
- Fixed "continuing indent not working": the autosave + format-on-save was
  reformatting with the formatters' own default indent width (clang-format
  defaults to 2 spaces), overwriting the editor's 8-space indentation on every
  save. Configured `clang_format` (`IndentWidth: 8, UseTab: Never`) and `stylua`
  (`--indent-type Spaces --indent-width 8`) in `lua/plugins/conform.lua` to match
  the editor. Go keeps its conventional tabs. Verified the clang-format style
  string produces 8-space output. Updated the editor-behaviour and tooling notes
  in the README.

### 2026-07-26 (tab width doubled to 8)
- Doubled the indentation width from 4 to 8 in `lua/config/options.lua`
  (`tabstop`, `shiftwidth`, `softtabstop` all now 8). Updated the
  editor-behaviour table in the README.

### 2026-07-26 (JetBrains-style indentation)
- Added `autoindent` and `softtabstop = 4` in `lua/config/options.lua` so
  pressing Enter carries the current line's indent onto the next line and
  Tab/Backspace move a full 4-space step. Tab = 4 spaces was already configured
  (`expandtab`, `tabstop`, `shiftwidth`). Updated the editor-behaviour table in
  the README.

### 2026-07-26 (C++ stdin from file)
- Added a `C++ build & run (input.txt)` Overseer task in
  `lua/config/overseer_tasks.lua`. Since the run output goes to the
  (non-interactive) quickfix window, this task lets you supply `cin` input from
  an `input.txt` file next to the source via shell redirection. It only
  redirects when `input.txt` exists, so programs needing no input still run.
  Documented in the task-runner table in the README.

### 2026-07-26 (graphical tab bar)
- Expanded the bufferline setup in `lua/plugins/ui.lua` to make the tab bar more
  graphical: slanted tab edges (`separator_style = "slant"`), colored filetype
  icons, per-tab close buttons, an underline indicator on the active tab, inline
  LSP error/warning badges, roomier tabs, and a titled "File Explorer" offset so
  tabs clear the nvim-tree sidebar. Updated the plugin table in the README.

### 2026-07-26 (line numbers)
- Turned off relative line numbering (`vim.opt.relativenumber = false`) in
  `lua/config/options.lua`; absolute line numbers stay on. Updated the
  editor-behaviour table in the README to match.

### 2026-07-26 (window navigation)
- Added window/split keymaps to `lua/config/keymaps.lua` to make moving between
  panes easier: `<C-h/j/k/l>` jump between windows, `<leader>sv`/`<leader>sh`
  split vertical/horizontal, `<leader>se` equalize, `<leader>sc` close,
  `<leader>so` close others, and `<C-arrow>` keys resize.
- Documented these in the README (new "Moving between windows (splits)" section
  and two Quick-reference rows).

### 2026-07-26
- Added a `CLAUDE.md` with the working rule to always log changes in this file.
- Added this Changelog section to the README.

### 2026-07-26 (later)
- Reworked `lua/plugins/completion.lua` so autocomplete accepts on **Tab** and
  **Enter** (was `<C-y>`-only via the `default` preset, which made completion
  feel broken). Switched to the `super-tab` preset with `<CR>` = accept.
- Enabled inline **ghost-text** preview, auto-showing menu, and top-item
  preselect so suggestions visibly complete.
- Updated the "Autocomplete pop-up" shortcuts table in the README to match.
