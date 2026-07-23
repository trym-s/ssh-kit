# nvim

Single lightweight Neovim config, identical on local WSL and SSH servers.
No LSP / completion / mason — syntax highlighting only. Yanks reach the
Windows clipboard over SSH via OSC 52 (auto-enabled in SSH sessions).

## Bootstrap a new server

Part of [ssh-kit](../README.md) — install via:

    git clone git@github.com:trym-s/ssh-kit.git ~/ssh-kit
    cd ~/ssh-kit && ./install.sh   # symlinks ~/.config/nvim -> ~/ssh-kit/nvim

Prerequisites on the host:
- Neovim >= 0.10
- ripgrep        (telescope live grep / find)
- a C compiler   (gcc/clang — treesitter parser builds)

First `nvim` launch installs plugins and parsers automatically.

## Update

    git -C ~/ssh-kit pull

## Clipboard

- Local WSL: existing provider (`y` -> Windows).
- SSH session: OSC 52 (`y` -> Windows clipboard, nothing installed remotely).
  Requires an OSC 52-capable terminal (Windows Terminal supports it).

## Layout

- `lua/core/`     options, keymaps, colors, palette, clipboard, lazy bootstrap
- `lua/plugins/`  oil (files), telescope (find), treesitter (highlight),
                  bufferline, lualine, autopairs, colorizer, notes
