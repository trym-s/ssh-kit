# ssh-kit

Portable dev environment for SSH-accessible servers. Clone once, run
`install.sh`, done. Ships a lightweight Neovim config and a zsh setup
(powerlevel10k, fzf-tab, syntax-highlighting, autosuggestions).

## Bootstrap a new server (Debian/Ubuntu)

    git clone https://github.com/trym-s/ssh-kit.git ~/ssh-kit
    cd ~/ssh-kit && ./install.sh

`install.sh` (idempotent, backs up existing real files to `*.bak`):

1. **apt-installs** deps — `neovim git ripgrep build-essential curl less zsh
   zsh-autosuggestions zsh-syntax-highlighting fzf bat eza zoxide`
   (each installed individually; ones missing on older releases are warned, not fatal).
2. Bridges Debian's `batcat` → `bat` in `~/.local/bin`.
3. For `eza`/`yazi` (often not in apt), downloads the latest prebuilt binary
   from GitHub releases into `~/.local/bin` (x86_64 / aarch64; yazi needs `unzip`).
4. Git-clones the non-apt zsh plugins into `~/.local/share/zsh/plugins/`:
   `powerlevel10k`, `fzf-tab`, `zsh-history-substring-search`.
5. Symlinks configs into place (see Layout).
6. Sets zsh as the login shell (`chsh`).

Then open a new shell (or `exec zsh`). First `nvim` launch installs plugins +
treesitter parsers automatically.

> Note: apt's `neovim` may be older than 0.10 on some releases — install a
> newer build manually if plugins complain about the version.

## Update

    git -C ~/ssh-kit pull

Symlinks mean pulled changes are live immediately (re-run `./install.sh` to
pick up new deps/plugins).

## Layout

symlinks created by `install.sh`:

| repo path            | linked to           |
|----------------------|---------------------|
| `nvim/`              | `~/.config/nvim`    |
| `zsh/dot-zshenv`     | `~/.zshenv`         |
| `zsh/dot-zshrc`      | `~/.zshrc`          |
| `zsh/config-zsh/`    | `~/.config/zsh`     |
| `zsh/config-p10k/`   | `~/.config/p10k`    |

Arch/WSL-specific bits in the zsh config (pacman aliases, `wl-copy` clipboard,
`/snap/bin` PATH) are guarded and simply don't activate on a plain apt server.
