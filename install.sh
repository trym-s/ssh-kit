#!/usr/bin/env sh
# ssh-kit installer — links config directories into place.
# Idempotent: safe to re-run. Existing real dirs are backed up to *.bak.
set -e

KIT_DIR="$(cd "$(dirname "$0")" && pwd)"

link() {
	src="$KIT_DIR/$1"
	dst="$2"
	mkdir -p "$(dirname "$dst")"
	if [ -L "$dst" ]; then
		rm -f "$dst"
	elif [ -e "$dst" ]; then
		echo "backup: $dst -> $dst.bak"
		mv "$dst" "$dst.bak"
	fi
	ln -sfn "$src" "$dst"
	echo "linked: $dst -> $src"
}

# nvim: ~/.config/nvim -> ssh-kit/nvim
link nvim "$HOME/.config/nvim"

echo
echo "Done. On first 'nvim' launch, plugins + treesitter parsers install automatically."
echo "Host prereqs: neovim >= 0.10, ripgrep, a C compiler (gcc/clang)."
