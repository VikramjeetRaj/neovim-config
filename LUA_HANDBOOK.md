# Lua Basics — A Beginner's Handbook

A compact reference to the Lua programming language — the language your Neovim `init.lua` is written in. It covers the fundamentals you need to read and edit config files (or write small programs) with confidence. No prior Lua experience assumed.

> **Search tip:** open in any Markdown viewer and use `Ctrl+F` / `Cmd+F` to jump to a topic (e.g. "table", "for loop", "function").

---

## Contents

1. [What is Lua?](#what-is-lua)
2. [Running Lua](#running-lua)
3. [Comments](#comments)
4. [Variables and scope](#variables-and-scope)
5. [Data types](#data-types)
6. [Numbers](#numbers)
7. [Strings](#strings)
8. [Booleans, nil, and truthiness](#booleans-nil-and-truthiness)
9. [Operators](#operators)
10. [Conditionals (if / elseif / else)](#conditionals-if--elseif--else)
11. [Loops](#loops)
12. [Functions](#functions)
13. [Tables (the one data structure)](#tables-the-one-data-structure)
14. [The string library](#the-string-library)
15. [Modules and require](#modules-and-require)
16. [Error handling (pcall)](#error-handling-pcall)
17. [Metatables (a peek)](#metatables-a-peek)
18. [Common idioms](#common-idioms)
19. [Common gotchas](#common-gotchas)
20. [Lua in Neovim](#lua-in-neovim)
21. [Cheat sheet](#cheat-sheet)

---

## What is Lua?

Lua is a small, fast, easy-to-embed scripting language. It's used to configure and extend larger programs — game engines, Redis, and **Neovim**. It has very few core concepts, which makes it quick to learn: variables, functions, and one flexible data structure called a **table**.

---

## Running Lua

- **Standalone:** install Lua (`brew install lua`) and run a file: `lua myfile.lua`, or start an interactive prompt by typing `lua`.
- **Inside Neovim:** run a line with `:lua print("hi")`, run a whole file with `:source %`, or just put code in `init.lua`.

```lua
print("Hello, world!")
```

---

## Comments

```lua
-- This is a single-line comment.

--[[
  This is a
  multi-line (block) comment.
]]
```

---

## Variables and scope

Assign with `=`. Lua is dynamically typed — a variable can hold any type and change type later.

```lua
local name = "Ada"     -- a local variable (preferred)
count = 10             -- a GLOBAL variable (avoid this)
```

**Always use `local`.** Without it, the variable becomes global and visible everywhere, which causes bugs. `local` limits the variable to the current block (file, function, loop, or `if`).

```lua
local x = 1
if true then
  local y = 2   -- y only exists inside this if-block
end
-- y is not accessible here
```

You can declare multiple variables at once:

```lua
local a, b, c = 1, 2, 3
local first, second = second, first  -- swap values in one line
```

---

## Data types

Lua has eight types. You'll use the first six constantly:

| Type | Example | Notes |
|---|---|---|
| `nil` | `nil` | "no value" / absence |
| `boolean` | `true`, `false` | |
| `number` | `42`, `3.14` | one numeric type (integers & floats) |
| `string` | `"hi"` | text |
| `function` | `function() end` | code you can call |
| `table` | `{1, 2, 3}` | arrays, dictionaries, objects — everything |
| `userdata` | (from C) | rarely written by hand |
| `thread` | (coroutines) | advanced |

Check a value's type with `type(x)`:

```lua
print(type("hi"))   -- string
print(type(10))     -- number
print(type(nil))    -- nil
```

---

## Numbers

```lua
local a = 10
local b = 3
print(a + b)   -- 13
print(a - b)   -- 7
print(a * b)   -- 30
print(a / b)   -- 3.333...
print(a % b)   -- 1   (remainder / modulo)
print(a ^ b)   -- 1000 (power)
```

Useful math functions live in the `math` library:

```lua
print(math.floor(3.7))   -- 3
print(math.max(1, 9, 4)) -- 9
print(math.random(1, 6)) -- a dice roll
```

---

## Strings

```lua
local a = "hello"
local b = 'world'          -- single or double quotes both work
local c = a .. " " .. b    -- .. joins strings -> "hello world"
print(#a)                  -- 5  (# gives length)
```

Multi-line strings use double square brackets:

```lua
local text = [[
Line one
Line two
]]
```

Numbers are auto-converted when concatenated:

```lua
print("count: " .. 5)   -- "count: 5"
```

See the [string library](#the-string-library) for more.

---

## Booleans, nil, and truthiness

Only **two** values are "falsy": `false` and `nil`. **Everything else is truthy** — including `0` and `""` (empty string), which surprises people from other languages.

```lua
if 0 then print("0 is truthy in Lua!") end   -- this DOES print
if "" then print("empty string too") end     -- this DOES print
```

`nil` means "not set". Accessing something that doesn't exist gives `nil` rather than an error.

---

## Operators

**Arithmetic:** `+  -  *  /  %  ^`

**Comparison:** `==` (equal), `~=` (not equal), `<`, `>`, `<=`, `>=`
> Note: "not equal" is `~=`, **not** `!=`.

**Logical:** `and`, `or`, `not` (words, not symbols)

```lua
if age >= 18 and hasTicket then ... end
if not done then ... end
```

`and` / `or` return one of their operands (not just true/false), which enables handy idioms — see [Common idioms](#common-idioms).

**Concatenation:** `..` (joins strings) — see [Strings](#strings).

---

## Conditionals (if / elseif / else)

```lua
local score = 75

if score >= 90 then
  print("A")
elseif score >= 70 then
  print("B")
else
  print("C")
end
```

No parentheses needed around the condition, and every block ends with `end`.

---

## Loops

**Numeric for** — count from a start to an end (inclusive), with an optional step:

```lua
for i = 1, 5 do        -- 1, 2, 3, 4, 5
  print(i)
end

for i = 10, 1, -2 do   -- 10, 8, 6, 4, 2  (step of -2)
  print(i)
end
```

**Generic for** — loop over a table with `ipairs` (arrays, in order) or `pairs` (all key/value pairs):

```lua
local fruits = { "apple", "banana", "cherry" }
for index, value in ipairs(fruits) do
  print(index, value)   -- 1 apple, 2 banana, 3 cherry
end

local person = { name = "Ada", age = 36 }
for key, value in pairs(person) do
  print(key, value)     -- name Ada, age 36 (order not guaranteed)
end
```

**While** and **repeat**:

```lua
local n = 1
while n <= 3 do
  print(n)
  n = n + 1
end

repeat
  n = n - 1
until n == 0   -- runs the body at least once, stops when condition is true
```

Use `break` to exit a loop early. (Lua has no `continue`.)

---

## Functions

```lua
local function add(a, b)
  return a + b
end

print(add(2, 3))   -- 5
```

Functions are values — you can store them in variables and pass them around:

```lua
local greet = function(name)
  return "Hello, " .. name
end
```

**Multiple return values:**

```lua
local function minmax(a, b)
  if a < b then return a, b else return b, a end
end

local lo, hi = minmax(9, 4)   -- lo = 4, hi = 9
```

**Variable arguments** (`...`):

```lua
local function sum(...)
  local total = 0
  for _, v in ipairs({ ... }) do   -- '...' collected into a table
    total = total + v
  end
  return total
end

print(sum(1, 2, 3, 4))   -- 10
```

> `_` is a conventional name for "a value I don't care about".

**Closures** — a function remembers the variables around it:

```lua
local function counter()
  local n = 0
  return function()
    n = n + 1
    return n
  end
end

local next = counter()
print(next())  -- 1
print(next())  -- 2
```

---

## Tables (the one data structure)

Tables are Lua's everything: arrays, dictionaries, objects, and modules are all tables.

**As an array (list):** indexes start at **1**, not 0.

```lua
local list = { "a", "b", "c" }
print(list[1])   -- "a"   (first element is index 1!)
print(#list)     -- 3     (# gives array length)
table.insert(list, "d")  -- append
table.remove(list, 1)    -- remove first
```

**As a dictionary (key/value map):**

```lua
local config = {
  theme = "mocha",
  number = true,
  tabstop = 4,
}
print(config.theme)      -- "mocha"   (dot access)
print(config["theme"])   -- same thing
config.newkey = "value"  -- add a key
```

**Nested tables** (very common in configs):

```lua
local opts = {
  window = { width = 80, height = 24 },
  keys = { "a", "b", "c" },
}
print(opts.window.width)  -- 80
print(opts.keys[2])       -- "b"
```

**Mixed** tables can hold both list items and named keys at once:

```lua
local t = { "first", "second", name = "example" }
print(t[1])     -- "first"
print(t.name)   -- "example"
```

Handy table functions: `table.insert`, `table.remove`, `table.concat(list, ", ")`, `table.sort(list)`.

---

## The string library

Call as `string.xxx(s, ...)` or, more commonly, as a method `s:xxx(...)`.

```lua
local s = "Hello, World"

print(s:upper())            -- "HELLO, WORLD"
print(s:lower())            -- "hello, world"
print(s:len())              -- 12   (same as #s)
print(s:sub(1, 5))          -- "Hello"  (substring, 1-based, inclusive)
print(s:find("World"))      -- 8 12   (start & end positions)
print(s:gsub("o", "0"))     -- "Hell0, W0rld"  2   (replace all + count)
print(("%d apples"):format(5))  -- "5 apples"  (like printf)

for word in ("a,b,c"):gmatch("[^,]+") do
  print(word)   -- a, then b, then c
end
```

---

## Modules and require

Split code into files and load them with `require`. A module is just a file that returns a table.

```lua
-- file: mymath.lua
local M = {}
function M.double(x) return x * 2 end
return M
```

```lua
-- another file
local mymath = require("mymath")
print(mymath.double(21))   -- 42
```

`require("a.b.c")` maps to the file path `a/b/c.lua`. Neovim plugins are loaded this way, e.g. `require("telescope").setup({})`.

---

## Error handling (pcall)

`pcall` ("protected call") runs a function and catches errors instead of crashing. It returns `ok` (a boolean) plus either the result or the error message.

```lua
local ok, result = pcall(function()
  error("something broke")
end)

if not ok then
  print("caught:", result)   -- caught: something broke
end
```

This is common in configs to safely try loading a plugin:

```lua
local ok, telescope = pcall(require, "telescope")
if not ok then
  return   -- plugin not installed; skip quietly
end
```

Raise your own error with `error("message")`.

---

## Metatables (a peek)

Metatables let a table change how it behaves — most usefully with `__index`, which provides fallback values for missing keys. You rarely need these as a beginner, but you'll see them.

```lua
local defaults = { color = "blue", size = 10 }
local settings = setmetatable({}, { __index = defaults })

print(settings.color)  -- "blue"  (falls back to defaults)
settings.color = "red"
print(settings.color)  -- "red"   (own value wins)
```

This is how Lua builds object-oriented "classes".

---

## Common idioms

**Default value** with `or` (if the left side is nil/false, use the right):

```lua
local function greet(name)
  name = name or "stranger"   -- fallback default
  print("Hi, " .. name)
end
```

**Ternary** (there's no `? :`) with `and`/`or`:

```lua
local status = isReady and "ready" or "waiting"
```

**Guard clause** — return early:

```lua
if not user then return end
```

**Build a table conditionally:**

```lua
local opts = { number = true }
if useRelative then opts.relativenumber = true end
```

---

## Common gotchas

| Gotcha | Remember |
|---|---|
| Indexing starts at **1** | `list[1]` is the first element, not `list[0]` |
| Variables are **global by default** | Always write `local` |
| `0` and `""` are **truthy** | Only `false` and `nil` are falsy |
| "Not equal" is `~=` | Not `!=` |
| No `+=`, `++`, or `continue` | Write `x = x + 1`; restructure loops instead of `continue` |
| Missing keys return `nil`, not an error | Check for `nil` before using |
| `#t` on a table with gaps is unreliable | `#` only works cleanly on gap-free arrays |
| Strings are immutable | String functions return *new* strings |

---

## Lua in Neovim

Your `init.lua` uses a few Neovim-specific building blocks, all built on the basics above.

**Options** — settings, via `vim.opt`:

```lua
vim.opt.number = true
vim.opt.tabstop = 4
```

**Keymaps** — `vim.keymap.set(mode, keys, action, options)`:

```lua
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "File tree" })
-- "n" = normal mode; the last argument is an options table
```

**Global variables** — `vim.g` (e.g. the leader key):

```lua
vim.g.mapleader = " "
```

**Calling plugins** — `require` a plugin table and call its `setup`:

```lua
require("gitsigns").setup({})
```

**Config is just tables** — plugin options are nested tables, exactly like the ones you learned above:

```lua
require("lualine").setup({
  options = { theme = "auto", globalstatus = true },
})
```

**Autocommands and callbacks** — pass a Lua function to run on an event:

```lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.bo.expandtab = false
  end,
})
```

Once you're comfortable with variables, functions, and tables, the whole `init.lua` reads as: *set some options, and call `setup({...})` on a list of plugins with table arguments.*

---

## Cheat sheet

```lua
-- Variables
local x = 10
local a, b = 1, 2

-- Strings
local s = "hi" .. " there"     -- concat
#s                              -- length
s:upper() / s:sub(1,2)         -- methods

-- Conditionals
if c then ... elseif d then ... else ... end

-- Loops
for i = 1, 5 do ... end                 -- numeric
for i, v in ipairs(list) do ... end     -- array
for k, v in pairs(map) do ... end       -- dictionary
while cond do ... end

-- Functions
local function f(a, b) return a + b end
local g = function(...) return ... end

-- Tables
local list = { "a", "b" }        -- list[1] == "a"
local map  = { key = "value" }   -- map.key
table.insert(list, "c")
table.remove(list, 1)

-- Safety
local ok, val = pcall(require, "mod")

-- Idioms
name = name or "default"
local r = cond and "yes" or "no"
```

---

*Reference: for the full language, see the official [Lua 5.1 manual](https://www.lua.org/manual/5.1/) (Neovim uses LuaJIT, which is Lua 5.1-compatible).*
