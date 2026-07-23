#!/usr/bin/env sh
# ssh-kit installer — apt deps + config symlinks for nvim and zsh.
# Idempotent: safe to re-run. Existing real files/dirs are backed up to *.bak.
# Targets Debian/Ubuntu (apt). Non-apt bits are skipped with a warning.
set -e

KIT_DIR="$(cd "$(dirname "$0")" && pwd)"

log()  { printf '\033[32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[33m[!] %s\033[0m\n' "$*" >&2; }

# --- sudo helper: empty when root, else `sudo`, else fail loudly -------------
if [ "$(id -u)" = 0 ]; then
	SUDO=""
elif command -v sudo >/dev/null 2>&1; then
	SUDO="sudo"
else
	SUDO=""
	warn "not root and no sudo — package installs may fail."
fi

# --- symlink helper ---------------------------------------------------------
link() {
	src="$KIT_DIR/$1"
	dst="$2"
	mkdir -p "$(dirname "$dst")"
	if [ -L "$dst" ]; then
		rm -f "$dst"
	elif [ -e "$dst" ]; then
		echo "  backup: $dst -> $dst.bak"
		mv "$dst" "$dst.bak"
	fi
	ln -sfn "$src" "$dst"
	echo "  linked: $dst -> $src"
}

# ============================================================================
# 1. apt packages
# ============================================================================
if command -v apt-get >/dev/null 2>&1; then
	log "Updating apt and installing packages"
	$SUDO apt-get update -qq || warn "apt-get update failed"

	# neovim + build deps, zsh + shell tooling. Installed one-by-one so a
	# package missing on older releases (eza/zoxide) doesn't abort the rest.
	for pkg in \
		neovim git ripgrep build-essential curl less unzip \
		zsh zsh-autosuggestions zsh-syntax-highlighting \
		fzf bat eza zoxide; do
		if $SUDO apt-get install -y -qq "$pkg" >/dev/null 2>&1; then
			echo "  ok: $pkg"
		else
			warn "apt package unavailable on this release: $pkg (install manually)"
		fi
	done
else
	warn "no apt-get found — skipping package install (install deps manually)."
fi

# Debian/Ubuntu ship bat as 'batcat'; the config calls 'bat'. Bridge it.
if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
	mkdir -p "$HOME/.local/bin"
	ln -sfn "$(command -v batcat)" "$HOME/.local/bin/bat"
	log "linked bat -> batcat in ~/.local/bin"
fi

# ============================================================================
# 1b. eza / yazi — not in older apt; grab prebuilt binaries into ~/.local/bin.
#     Uses GitHub's /releases/latest/download (version-agnostic).
# ============================================================================
case "$(uname -m)" in
	x86_64|amd64)  ARCH=x86_64 ;;
	aarch64|arm64) ARCH=aarch64 ;;
	*)             ARCH="" ;;
esac
TARGET="${ARCH}-unknown-linux-gnu"
mkdir -p "$HOME/.local/bin"

if [ -z "$ARCH" ]; then
	warn "unknown CPU arch $(uname -m) — skipping eza/yazi binary install."
elif ! command -v curl >/dev/null 2>&1; then
	warn "curl missing — skipping eza/yazi binary install."
else
	# eza: a .tar.gz holding a single binary.
	if ! command -v eza >/dev/null 2>&1; then
		log "installing eza (prebuilt $TARGET binary)"
		if curl -fsSL "https://github.com/eza-community/eza/releases/latest/download/eza_${TARGET}.tar.gz" \
			| tar xz -C "$HOME/.local/bin" 2>/dev/null; then
			chmod +x "$HOME/.local/bin/eza" 2>/dev/null || true
			echo "  ok: eza"
		else
			warn "eza download failed — 'ls' aliases will fall back to plain ls."
		fi
	fi

	# yazi: a .zip holding yazi + ya inside a versioned dir (needs unzip).
	if ! command -v yazi >/dev/null 2>&1; then
		if command -v unzip >/dev/null 2>&1; then
			log "installing yazi (prebuilt $TARGET binary)"
			ytmp="$(mktemp -d)"
			if curl -fsSL "https://github.com/sxyazi/yazi/releases/latest/download/yazi-${TARGET}.zip" -o "$ytmp/yazi.zip" \
				&& unzip -q "$ytmp/yazi.zip" -d "$ytmp"; then
				install -m755 "$ytmp"/yazi-*/yazi "$HOME/.local/bin/yazi" && echo "  ok: yazi" || warn "yazi binary not found in archive."
				install -m755 "$ytmp"/yazi-*/ya   "$HOME/.local/bin/ya" 2>/dev/null || true
			else
				warn "yazi download failed — the 'y' file-manager function will be inactive."
			fi
			rm -rf "$ytmp"
		else
			warn "unzip missing — skipping yazi (install unzip, or 'cargo install --locked yazi-fs yazi-cli')."
		fi
	fi
fi

# ============================================================================
# 2. zsh plugins not in apt (cloned into ~/.local/share/zsh/plugins)
# ============================================================================
ZPLUG="$HOME/.local/share/zsh/plugins"
mkdir -p "$ZPLUG"
clone() { # name url
	dir="$ZPLUG/$1"
	if [ -d "$dir/.git" ]; then
		echo "  up-to-date: $1"; git -C "$dir" pull --quiet --ff-only || true
	else
		log "cloning $1"
		git clone --depth=1 --quiet "$2" "$dir"
	fi
}
clone powerlevel10k                https://github.com/romkatv/powerlevel10k.git
clone fzf-tab                      https://github.com/Aloxaf/fzf-tab.git
clone zsh-history-substring-search https://github.com/zsh-users/zsh-history-substring-search.git

# ============================================================================
# 3. config symlinks
# ============================================================================
log "Linking configs"
link nvim              "$HOME/.config/nvim"
link zsh/dot-zshenv    "$HOME/.zshenv"
link zsh/dot-zshrc     "$HOME/.zshrc"
link zsh/config-zsh    "$HOME/.config/zsh"
link zsh/config-p10k   "$HOME/.config/p10k"

# ============================================================================
# 4. make zsh the login shell
# ============================================================================
ZSH_BIN="$(command -v zsh || true)"
if [ -n "$ZSH_BIN" ]; then
	case "$SHELL" in
		*/zsh) : ;;
		*)
			log "Setting login shell to zsh ($ZSH_BIN)"
			grep -qx "$ZSH_BIN" /etc/shells 2>/dev/null || \
				echo "$ZSH_BIN" | $SUDO tee -a /etc/shells >/dev/null
			chsh -s "$ZSH_BIN" || warn "chsh failed — run 'chsh -s $ZSH_BIN' manually."
			;;
	esac
fi

echo
log "Done."
echo "  - Open a new shell (or 'exec zsh') to load the zsh config."
echo "  - First 'nvim' launch installs plugins + treesitter parsers automatically."
echo "  - nvim needs >= 0.10; if apt's neovim is older, install a newer build manually."
