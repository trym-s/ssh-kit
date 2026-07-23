# Portable Slim Neovim Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Turn the heavy WSL Neovim config into one lightweight, LSP-free config that runs identically on local WSL and ~10 SSH servers, with yanks reaching the Windows clipboard over SSH.

**Architecture:** Single unified config in a git repo at `~/.config/nvim`. Remove the entire LSP/completion/mason stack and neo-tree. Keep oil, telescope, treesitter (slim), and the shared core. Clipboard provider is auto-selected at startup: OSC 52 in an SSH session, existing provider locally.

**Tech Stack:** Neovim 0.11.6, lazy.nvim, Lua. Verification via `nvim --headless`.

## Global Constraints

- Neovim >= 0.10 required (OSC 52 built-in provider `vim.ui.clipboard.osc52`). Target box is 0.11.6. Do NOT use APIs requiring 0.12.
- treesitter stays on `branch = "master"` (0.12 `main` branch unsupported here).
- Single treesitter parser set everywhere: `bash`, `python`, `go`, `html`, `css`, `javascript`.
- `opt.clipboard = "unnamedplus"` stays set for both environments.
- Keep `nvim-web-devicons` (oil / bufferline / lualine depend on it). Drop only neo-tree + nui.
- Frequent commits: one commit per task.
- All commits end with the Co-Authored-By trailer used in prior commits in this repo.

---

### Task 1: SSH-aware clipboard module

**Files:**
- Create: `lua/core/clipboard.lua`
- Modify: `init.lua` (add one require)

**Interfaces:**
- Produces: module `core.clipboard`, side-effecting on require — sets `vim.g.clipboard` to the OSC 52 provider when in an SSH session, otherwise leaves the default (existing local provider) untouched.
- Consumes: nothing from other tasks.

- [ ] **Step 1: Write the clipboard module**

Create `lua/core/clipboard.lua`:

```lua
-- Auto-select clipboard provider by environment.
-- SSH session: route yanks to the LOCAL (Windows) clipboard via OSC 52,
-- so `y` in a remote nvim reaches the Windows clipboard with nothing
-- installed on the server. Paste stays local (OSC 52 paste is unreliable).
-- Local WSL: leave the existing working provider in place.

local in_ssh = vim.env.SSH_TTY ~= nil or vim.env.SSH_CONNECTION ~= nil

if in_ssh then
  local ok, osc52 = pcall(require, "vim.ui.clipboard.osc52")
  if ok then
    vim.g.clipboard = {
      name = "OSC 52",
      copy = {
        ["+"] = osc52.copy("+"),
        ["*"] = osc52.copy("*"),
      },
      paste = {
        ["+"] = osc52.paste("+"),
        ["*"] = osc52.paste("*"),
      },
    }
  end
end
```

- [ ] **Step 2: Wire it into init.lua**

Modify `init.lua` — add the clipboard require after options (so `clipboard = unnamedplus` is already set):

```lua
require("core.options")
require("core.clipboard")
require("core.keymaps")
require("core.lazy")
require("core.colors")
```

- [ ] **Step 3: Verify local path leaves default provider**

Run:
```bash
nvim --headless -c 'lua io.write(tostring(vim.g.clipboard))' -c 'qa' 2>&1
```
Expected: prints `nil` (no SSH env locally → default provider untouched, no error).

- [ ] **Step 4: Verify SSH path selects OSC 52**

Run:
```bash
SSH_TTY=/dev/pts/0 nvim --headless -c 'lua io.write((vim.g.clipboard or {}).name or "none")' -c 'qa' 2>&1
```
Expected: prints `OSC 52`.

- [ ] **Step 5: Commit**

```bash
cd ~/.config/nvim
git add lua/core/clipboard.lua init.lua
git commit -m "feat: SSH-aware clipboard, OSC52 over SSH

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 2: Remove the LSP + completion stack

**Files:**
- Delete: `lua/plugins/lsp.lua`
- Delete: `lua/plugins/cmp.lua`

**Interfaces:**
- Consumes: nothing.
- Produces: no config loads mason / lspconfig / cmp. lazy auto-discovers `lua/plugins/*.lua`, so deleting the files removes the specs — no reference edits needed.

- [ ] **Step 1: Delete the two plugin specs**

Run:
```bash
cd ~/.config/nvim
git rm lua/plugins/lsp.lua lua/plugins/cmp.lua
```

- [ ] **Step 2: Sync lazy to uninstall removed plugins**

Run:
```bash
nvim --headless "+Lazy! sync" +qa 2>&1 | tail -5
```
Expected: completes without error; mason, mason-lspconfig, nvim-lspconfig, nvim-cmp, LuaSnip, cmp-nvim-lsp reported as cleaned/removed.

- [ ] **Step 3: Verify no LSP clients attach**

Run:
```bash
nvim --headless test-file.py -c 'lua vim.defer_fn(function() io.write(tostring(#vim.lsp.get_clients())) vim.cmd("qa") end, 300)' 2>&1
```
Expected: prints `0`.

- [ ] **Step 4: Verify config still starts clean**

Run:
```bash
nvim --headless -c 'qa' 2>&1
```
Expected: no output, exit 0 (no errors from dangling requires).

- [ ] **Step 5: Commit**

```bash
cd ~/.config/nvim
git add -A
git commit -m "refactor: drop LSP, completion, and mason entirely

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 3: Remove neo-tree, keep oil as the sole explorer

**Files:**
- Delete: `lua/plugins/neo-tree.lua`

**Interfaces:**
- Consumes: `oil.lua` (unchanged) remains the file explorer, bound to `<leader>o` and `-`.
- Produces: neo-tree + nui removed; devicons retained (oil depends on it).

- [ ] **Step 1: Delete neo-tree spec**

Run:
```bash
cd ~/.config/nvim
git rm lua/plugins/neo-tree.lua
```

- [ ] **Step 2: Sync lazy to uninstall neo-tree + nui**

Run:
```bash
nvim --headless "+Lazy! sync" +qa 2>&1 | tail -5
```
Expected: completes; neo-tree.nvim and nui.nvim reported cleaned. nvim-web-devicons stays (oil/bufferline/lualine deps).

- [ ] **Step 3: Verify oil still opens**

Run:
```bash
nvim --headless -c 'Oil' -c 'lua io.write(vim.bo.filetype)' -c 'qa' 2>&1
```
Expected: prints `oil`.

- [ ] **Step 4: Commit**

```bash
cd ~/.config/nvim
git add -A
git commit -m "refactor: drop neo-tree, oil is the sole file explorer

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 4: Slim the treesitter parser set

**Files:**
- Modify: `lua/plugins/treesitter.lua` (the `parsers` and `filetypes` lists)

**Interfaces:**
- Consumes: nothing.
- Produces: parsers limited to `bash`, `python`, `go`, `html`, `css`, `javascript`. Missing-parser files fall back to regex highlight (no error).

- [ ] **Step 1: Replace the parser and filetype lists**

In `lua/plugins/treesitter.lua`, replace the `parsers` table with:

```lua
local parsers = {
  "bash",
  "python",
  "go",
  "html",
  "css",
  "javascript",
}
```

and replace the `filetypes` table with:

```lua
local filetypes = {
  "bash",
  "sh",
  "python",
  "go",
  "html",
  "css",
  "javascript",
}
```

Leave the rest of the file (branch, build, config, autocmd) unchanged.

- [ ] **Step 2: Install the new parser set**

Run:
```bash
nvim --headless "+TSUpdateSync" +qa 2>&1 | tail -5
```
Expected: installs/updates bash, python, go, html, css, javascript without error.

- [ ] **Step 3: Verify highlight activates on a Python file**

Run:
```bash
printf 'def f():\n    return 1\n' > /tmp/ts-check.py
nvim --headless /tmp/ts-check.py -c 'lua vim.defer_fn(function() io.write(tostring(vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil)) vim.cmd("qa") end, 300)' 2>&1
rm -f /tmp/ts-check.py
```
Expected: prints `true`.

- [ ] **Step 4: Commit**

```bash
cd ~/.config/nvim
git add lua/plugins/treesitter.lua
git commit -m "refactor: slim treesitter parsers to bash/python/go/html/css/js

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 5: Disable lazy background update checker

**Files:**
- Modify: `lua/core/lazy.lua` (the `checker` block)

**Interfaces:**
- Consumes: nothing.
- Produces: no periodic background git fetches for plugin updates.

- [ ] **Step 1: Turn the checker off**

In `lua/core/lazy.lua`, change the `checker` block from:

```lua
  checker = {
    enabled = true,
    notify = false,
  },
```

to:

```lua
  checker = {
    enabled = false,
  },
```

Leave `change_detection = { notify = false }` as-is.

- [ ] **Step 2: Verify config starts clean**

Run:
```bash
nvim --headless -c 'lua io.write("ok")' -c 'qa' 2>&1
```
Expected: prints `ok`, no errors.

- [ ] **Step 3: Commit**

```bash
cd ~/.config/nvim
git add lua/core/lazy.lua
git commit -m "perf: disable lazy background update checker

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 6: Reclaim disk — remove leftover mason tree

**Files:** none (on-disk state only)

**Interfaces:**
- Consumes: Task 2 removed the mason plugin; this deletes the ~513MB server-binary tree it left behind.
- Produces: `~/.local/share/nvim/mason` gone.

- [ ] **Step 1: Confirm mason plugin is gone before deleting binaries**

Run:
```bash
test ! -d ~/.local/share/nvim/lazy/mason.nvim && echo "plugin removed" || echo "STOP: mason plugin still present"
```
Expected: prints `plugin removed`. If it prints STOP, finish Task 2 first.

- [ ] **Step 2: Delete the mason binary tree**

Run:
```bash
rm -rf ~/.local/share/nvim/mason
```

- [ ] **Step 3: Verify footprint dropped**

Run:
```bash
du -sh ~/.local/share/nvim 2>/dev/null
```
Expected: total is now on the order of tens of MB (lazy plugins + parsers), not ~588MB.

- [ ] **Step 4: (no commit — on-disk state, nothing tracked changed)**

---

### Task 7: Repo hygiene + bootstrap README

**Files:**
- Create: `README.md`
- Verify: `.gitignore` (created during brainstorming) ignores `.profile`; extend if needed.

**Interfaces:**
- Consumes: the finished config.
- Produces: a documented one-line bootstrap and prerequisites for new servers.

- [ ] **Step 1: Confirm lazy-lock.json reflects the removals**

Run:
```bash
cd ~/.config/nvim
grep -E 'mason|lspconfig|nvim-cmp|LuaSnip|cmp-nvim-lsp|neo-tree|nui' lazy-lock.json || echo "clean"
```
Expected: prints `clean` (removed plugins no longer locked). If entries remain, run `nvim --headless "+Lazy! sync" +qa` then re-check.

- [ ] **Step 2: Write the README**

Create `README.md`:

```markdown
# nvim

Single lightweight Neovim config, identical on local WSL and SSH servers.
No LSP / completion / mason — syntax highlighting only. Yanks reach the
Windows clipboard over SSH via OSC 52 (auto-enabled in SSH sessions).

## Bootstrap a new server

    git clone <this-repo-url> ~/.config/nvim

Prerequisites on the host:
- Neovim >= 0.10
- ripgrep        (telescope live grep / find)
- a C compiler   (gcc/clang — treesitter parser builds)

First `nvim` launch installs plugins and parsers automatically.

## Update

    git -C ~/.config/nvim pull

## Clipboard

- Local WSL: existing provider (`y` -> Windows).
- SSH session: OSC 52 (`y` -> Windows clipboard, nothing installed remotely).
  Requires an OSC 52-capable terminal (Windows Terminal supports it).
```

Replace `<this-repo-url>` with the actual remote once created.

- [ ] **Step 3: Confirm .gitignore ignores the state marker**

Run:
```bash
cd ~/.config/nvim
grep -qx '.profile' .gitignore && echo "ok" || printf '.profile\n' >> .gitignore
```
Expected: prints `ok` (already present from brainstorming).

- [ ] **Step 4: Commit**

```bash
cd ~/.config/nvim
git add README.md .gitignore lazy-lock.json
git commit -m "docs: bootstrap README and repo hygiene

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

- [ ] **Step 5: (manual, user) create remote and push**

The user creates the GitHub/company git remote, then:
```bash
cd ~/.config/nvim
git remote add origin <url>
git push -u origin <default-branch>
```
Update the README URL placeholder and amend if desired.

---

### Task 8: Full-config smoke verification

**Files:** none

**Interfaces:**
- Consumes: everything above.
- Produces: recorded evidence the config is healthy and slim.

- [ ] **Step 1: Clean startup + plugin health**

Run:
```bash
nvim --headless "+Lazy! sync" +qa 2>&1 | tail -3
nvim --headless -c 'checkhealth lazy' -c 'w! /tmp/health.txt' -c 'qa' 2>&1; tail -20 /tmp/health.txt; rm -f /tmp/health.txt
```
Expected: sync clean; no ERROR lines in lazy health.

- [ ] **Step 2: Confirm no LSP anywhere**

Run:
```bash
printf 'print("hi")\n' > /tmp/smoke.py
nvim --headless /tmp/smoke.py -c 'lua vim.defer_fn(function() io.write("clients="..#vim.lsp.get_clients()) vim.cmd("qa") end, 300)' 2>&1
rm -f /tmp/smoke.py
```
Expected: prints `clients=0`.

- [ ] **Step 3: Confirm core plugins load (oil, telescope, treesitter highlight)**

Run:
```bash
nvim --headless -c 'lua io.write("oil="..tostring(pcall(require,"oil"))..",tel="..tostring(pcall(require,"telescope")))' -c 'qa' 2>&1
```
Expected: prints `oil=true,tel=true`.

- [ ] **Step 4: Record final footprint**

Run:
```bash
du -sh ~/.config/nvim ~/.local/share/nvim 2>/dev/null
```
Expected: `~/.local/share/nvim` is tens of MB (down from ~588MB). Note the number.

- [ ] **Step 5: Manual OSC 52 check (user, on a real server)**

On an actual SSH server (Windows Terminal), open a file, `yy` a line, then paste
(Ctrl+V) into a Windows app. Expected: the yanked line pastes. This confirms OSC 52
end-to-end — it cannot be verified headless from local.
