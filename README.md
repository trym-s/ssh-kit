# ssh-kit

Portable dev environment for SSH-accessible servers. Clone once, symlink into
place, done. Currently ships a single lightweight Neovim config.

## Bootstrap a new server

    git clone git@github.com:trym-s/ssh-kit.git ~/ssh-kit
    cd ~/ssh-kit && ./install.sh

`install.sh` symlinks `~/.config/nvim -> ~/ssh-kit/nvim` (backing up any
existing real dir to `*.bak`). First `nvim` launch installs plugins + parsers.

Host prerequisites:
- Neovim >= 0.10
- ripgrep        (telescope live grep / find)
- a C compiler   (gcc/clang — treesitter parser builds)

## Update

    git -C ~/ssh-kit pull

Symlinks mean the pulled changes are live immediately.

## Layout

- `nvim/`       Neovim config (see `nvim/README.md`)
- `install.sh`  symlinks each component into place
