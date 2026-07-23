# Portable Slim Neovim — Design

Date: 2026-07-22
Status: Approved

## Problem

The WSL Neovim config is heavy: ~588MB on disk, of which ~513MB is `mason`
(downloaded LSP servers) and ~76MB is lazy plugins. At runtime, LSP clients +
`nvim-cmp` + `LuaSnip` spawn background processes on every opened file. The user
writes code with an agent, not the editor's LSP, so **LSP is not needed at all**
— syntax highlighting is enough. The goal is one lightweight config that runs
identically on the local WSL box and on ~10 (growing) SSH servers — company dev
boxes and personal VPSes, all with internet — with a small footprint and few
running processes. Yanks from a remote nvim over SSH must reach the Windows
clipboard.

## Goals

- One config, identical keymaps / colors / file-exploring on every machine.
- No LSP, no completion engine, no mason — anywhere.
- Small footprint and minimal background processes, local and remote.
- Yank in a remote nvim lands in the Windows clipboard, nothing extra installed
  on the server.
- Trivial per-server bootstrap and update (git clone / git pull).

## Non-goals

- No LSP, diagnostics, or autocompletion.
- No VS Code Remote-SSH-style tunneling (`remote-nvim.nvim`) or `sshfs` mounts —
  the servers are persistent, so a cloned dotfiles config gives the same
  experience with fewer moving parts.
- No profile machinery. LSP was the only real reason to split local vs server;
  with LSP gone everywhere, a single config is simplest (YAGNI). If a local-only
  plugin is ever wanted, a one-line `full` gate can be reintroduced then.

## Architecture: single unified slim config

`~/.config/nvim` becomes a git repo (dotfiles). The exact same config runs
everywhere. The only environment-dependent behavior is the clipboard provider,
auto-detected at startup — no marker file, no profile flag.

### Repo layout

```
~/.config/nvim/
├── .gitignore             # ignores nvim state, not config
├── init.lua               # shared require()s
└── lua/
    ├── core/
    │   ├── options.lua     # unchanged (keeps clipboard = unnamedplus)
    │   ├── keymaps.lua     # unchanged
    │   ├── colors.lua      # unchanged
    │   ├── palette.lua     # unchanged
    │   ├── clipboard.lua   # NEW: SSH → OSC52, else local provider
    │   └── lazy.lua        # checker disabled
    └── plugins/
        ├── oil.lua         # file explorer
        ├── telescope.lua   # fuzzy find (needs ripgrep on host)
        ├── treesitter.lua  # slimmed parser set
        ├── bufferline.lua
        ├── ui.lua          # lualine
        ├── autopairs.lua
        └── notes.lua       # render-markdown / todo-comments
```

## Changes

### Removed entirely (everywhere)

- `mason.nvim`, `mason-lspconfig.nvim`, `nvim-lspconfig` (delete `lua/plugins/lsp.lua`)
- `nvim-cmp`, `LuaSnip`, `cmp-nvim-lsp` (delete `lua/plugins/cmp.lua`)
- `neo-tree.nvim`, `nui.nvim`, `nvim-web-devicons` (delete `lua/plugins/neo-tree.lua`)
- The `~/.local/share/nvim/mason` tree (~513MB).
- LSP `LspAttach` keymaps and the completion mappings disappear with the above.
  Intentionally lost: `gd`, `gr`, `K` (hover), `<leader>rn`, `<leader>ca`,
  diagnostics `[d]`/`]d`, and autocompletion. Accepted — code is written via an
  agent.

### Kept

- `oil.nvim` — the single file explorer everywhere (replaces neo-tree).
- `telescope.nvim` + `plenary.nvim` — fuzzy find. Requires `ripgrep` on the host.
- `nvim-treesitter` — highlight only, slim parser set (below).
- `bufferline.nvim`, `lualine.nvim`, `nvim-autopairs`, `nvim-colorizer`.
- `render-markdown.nvim`, `todo-comments.nvim`.
- All of `core/` (options, keymaps, colors, palette).

### Treesitter parser set

Single global list: `bash`, `python`, `go`, `html`, `css`, `javascript`.
A file whose parser is not installed falls back to regex syntax highlighting —
no error. Parsers build via a C compiler on each host (gcc; internet available).

### Clipboard — `core/clipboard.lua`

Auto-detect at startup:

- **SSH session** (`vim.env.SSH_TTY` or `SSH_CONNECTION` set): set
  `vim.g.clipboard` to the OSC 52 provider (Neovim 0.10+ ships
  `vim.ui.clipboard.osc52`). With `clipboard = unnamedplus`, `y` emits an OSC 52
  escape the terminal routes into the **local Windows clipboard** — over any SSH
  hop, no X-forwarding, nothing installed on the server. Windows Terminal
  supports OSC 52. Paste stays local (OSC 52 paste is unreliable); acceptable.
- **Not SSH** (local WSL): leave the existing working provider in place (`y` →
  Windows already works via clip.exe/win32yank).

`opt.clipboard = "unnamedplus"` stays in `options.lua`.

### lazy.nvim

- Disable `checker.enabled` (periodic background update checks). Keep
  `change_detection.notify = false`.

## Deployment

- Push repo to GitHub / company git.
- New server: `git clone <repo> ~/.config/nvim`, then install `ripgrep` and a C
  compiler (documented in repo README).
- Update: `git pull` in `~/.config/nvim` (optional `nvim-sync` shell alias).
- `.gitignore` covers nvim state; no per-server marker files needed.

## Verification

- `nvim --headless "+Lazy! sync" +qa` runs clean.
- `nvim --headless -c 'lua print(#vim.lsp.get_clients())' -c 'qa'` prints `0`;
  `~/.local/share/nvim/mason` absent after cleanup.
- Disk footprint of `~/.local/share/nvim` measured and recorded (target: a few
  MB of plugins + parsers, not hundreds).
- Real SSH server: `y` in nvim, paste into a Windows app → text arrives (OSC 52
  end to end).
- Local: file explorer (oil), telescope find, treesitter highlight, keymaps,
  colors all still work; local clipboard still works.

## Risks / notes

- OSC 52 has a payload-size ceiling for very large yanks; fine for normal editing.
- Telescope needs `ripgrep`; treesitter needs a C compiler — both documented as
  bootstrap prerequisites.
