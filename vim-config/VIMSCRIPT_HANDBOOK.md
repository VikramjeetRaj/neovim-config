# Vimscript Handbook

A companion to the README, like the source repository's Lua handbook. Use this to change the configuration without having to learn all of Vimscript at once.

## 1. Entry point and execution order

Vim reads `vimrc` from top to bottom. `source path` executes another Vimscript file. This entry point resolves its own real directory, puts it on `runtimepath`, and sources the modules in an explicit order. `runtimepath` tells Vim where to find autoload functions, colours, plugin files, and documentation.

```vim
execute 'source ' . fnameescape(g:vim_config_root . '/config/options.vim')
```

`.` concatenates strings. `execute` builds and runs an Ex command. `fnameescape()` protects spaces and special characters in paths passed to Ex commands. It is different from `shellescape()`, which protects arguments passed to a shell.

## 2. Variables and scope

| Prefix | Scope | Example |
|---|---|---|
| `g:` | Global, shared by modules | `g:vim_config_root` |
| `s:` | Current script only | `s:terms` |
| `l:` | Current function | `l:tasks` |
| `a:` | Function argument | `a:markers` |
| `b:` | Current buffer | `b:vim_config_blame` |
| `v:` | Built-in Vim state | `v:shell_error` |
| `&` | Editor option | `&filetype`, `&modified` |
| `$` | Environment variable | `$PATH` |

Use `let` to assign variables. Use `get(dict, key, default)` when a key may be absent. `get(g:, 'vim_config_no_plugins', 0)` reads a global option with a default of zero.

Single-quoted strings are mostly literal; double-quoted strings interpret escapes such as `\n` and `\<CR>`. For example, a single backslash is `'\'`; a double-quoted backslash must be escaped. Comments begin with `"` outside a string.

## 3. Options

`set` changes options; `setlocal` changes the current buffer/window setting. Boolean options are enabled by name and disabled with `no`:

```vim
set number
set norelativenumber
set shiftwidth=8
setlocal noexpandtab
```

`filetype plugin indent on` loads Vim's language-specific defaults. Our FileType autocommands apply the chosen 8-column policy afterward, with real tabs for Go and Make.

## 4. Lists, dictionaries, and expressions

```vim
let l:args = ['go', 'test', '-v', './...']
let l:task = {'name': 'Go test', 'cwd': getcwd()}
call add(l:args, '-count=1')
```

Lists use brackets, dictionaries use braces. Indexes start at zero. `+` joins lists; `.` joins strings. `==#` compares strings case-sensitively regardless of editor search options. `=~#` matches a regular expression case-sensitively. `condition ? yes : no` is a conditional expression. `empty(value)` tests for an empty string/list/dictionary.

A line beginning with `\` continues the previous Vimscript statement. `|` separates Ex commands on one line; mappings must use `<Bar>` when they need a literal command separator.

## 5. Functions and autoload

```vim
function! Example(message) abort
        echom a:message
endfunction
call Example('Hello')
```

`function!` replaces a prior definition. `abort` stops the function on errors. `echom` records a message in `:messages`. `echoerr` reports an error.

An autoload function named `vimconfig#root` belongs in `autoload/vimconfig.vim`. Vim loads it on first use. Keep generic helpers there; UI actions stay in their relevant modules.

`function('Name', [value1, value2])` creates a function reference with captured leading arguments. Build-and-debug uses this to remember the source executable and input file before the active buffer changes to quickfix.

## 6. Mappings

```vim
nnoremap <silent> <leader>x :bdelete<CR>
nmap <silent> gd <Plug>(coc-definition)
inoremap <expr> <CR> SomeCondition() ? SomeResult() : "\<CR>"
```

`n` means Normal, `i` Insert, `t` terminal. `noremap` avoids recursively expanding the replacement. `nmap` is appropriate for plugin `<Plug>` mappings. `<expr>` evaluates an expression to choose which keys to send. `<silent>` suppresses command echo. `<buffer>` limits a mapping to the current buffer, as on the dashboard.

Leader must be set before declaring mappings. Check what owns a key with `:verbose nmap <leader>x`. Completion expressions guard missing plugin functions so native insertion works before installation.

## 7. Autocommands

```vim
augroup MyFeature
        autocmd!
        autocmd BufWritePre * call MyFormat()
augroup END
```

An autocommand runs on an editor event. Named groups with `autocmd!` replace only their own hooks when sourced again. Important events here are FileType, BufWritePre, InsertLeave, TextChanged, BufLeave, FocusLost, CursorHold, and VimEnter.

Autosave excludes special buffers and readonly/unnamed files. Format-on-save runs before a write, so it also applies to autosaves. A task can switch the current window before its async callback fires; capture file-specific values before launching it.

## 8. Processes and quoting

Use argument lists with `job_start()` and `term_start()` wherever possible. When you need shell features such as `&&` or input redirection, build each argument with `shellescape()`:

```vim
let l:command = vimconfig#shell(['g++', '-g', expand('%:p')])
```

Never concatenate a raw filename into a shell command. `system(command, input)` runs synchronously, supplies stdin, and returns stdout. Check `v:shell_error` immediately afterward. Formatting computes results first and only changes the buffer after all selected commands succeed.

The task runner uses `job_start()` so Vim stays responsive. Output callbacks collect complete lines; the channel close callback runs after output closes, reads the exit status, and publishes quickfix entries. A captured callback starts debugging only on exit zero. Use `:VimTaskStop` to interrupt.

## 9. Native terminal buffers

`term_start(argv, options)` starts a job connected to a terminal emulator buffer. The persistent shell manager stores buffer numbers by session ID and hides windows rather than killing jobs. `term_getstatus()` checks whether a shell still runs; `bufwinid()` finds a visible window. Vim's terminal mode is different from Neovim's: Ctrl+w is the built-in terminal command prefix.

## 10. Plugin settings

Plugin globals that affect initialization belong before `plug#end()` in `config/plugins.vim`. Vimscript UI settings live in modules; CoC's JSON settings live in `coc-settings.json`. JSON needs double-quoted keys, has `true`/`false`, and does not allow trailing commas. Vimscript uses `v:true`/`v:false` when a real JSON boolean is needed by debug adapters.

To add a plugin, add its `Plug 'owner/repo'` line, run `:PlugInstall`, restart, and document it. Vimspector is declared only when Vim has Python support so the rest of the configuration works on the system Vim.

## 11. Customization recipes

- Different indentation: update `options.vim`, FileType rules in `autocmds.vim`, and formatter flags in `format.vim` together.
- Different leader: set `mapleader` at the start of `options.vim`, then restart.
- Add a task: append a dictionary with `name`, `cmd`, and `cwd` in `VimConfigTaskSpecs()` for the appropriate filetype or project root.
- Add a server: add a CoC extension to `g:coc_global_extensions`; configure it in JSON; restart or use `:CocInstall`.
- Disable autosave: remove the autosave autocmd in `autocmds.vim`; keep BufWritePre if you still want formatting on explicit saves.
- Change theme: change the Plug declaration, theme globals, and colour command in `ui.vim`.

## 12. Troubleshooting and validating edits

Use `:messages` for errors, `:scriptnames` for load order, `:verbose set shiftwidth?` for the last option setter, and `:VimConfigHealth` for dependencies. Run `sh scripts/validate.sh` after edits. Keep README shortcuts and the dated changelog accurate.
