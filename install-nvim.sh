#!/usr/bin/env bash
# install-nvim.sh — Install Neovim (AppImage) + this config inside a dev container
# Usage: bash install-nvim.sh
#
# Run this from inside the container (e.g. as a devcontainer.json postCreateCommand).
# It mirrors deploy-nvim.sh, minus the ssh/rsync — everything happens locally.

set -euo pipefail

# ─── Config ───────────────────────────────────────────────────────────────────
NVIM_VERSION="v0.11.6"
NVIM_SHA256="77dd16d86e6549a0bbbbfbc18636d434ffe5b0ac8b9854a7669e35cc4b93dda0"
NVIM_URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.appimage"

RIPGREP_VERSION="15.1.0"
RIPGREP_TARBALL="ripgrep-${RIPGREP_VERSION}-x86_64-unknown-linux-musl.tar.gz"
RIPGREP_URL="https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VERSION}/${RIPGREP_TARBALL}"

CONFIG_REPO="https://github.com/kcmnd/nvim"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
# ──────────────────────────────────────────────────────────────────────────────

echo "══════════════════════════════════════════════════════"
echo "  Installing Neovim + config in dev container"
echo "══════════════════════════════════════════════════════"

mkdir -p ~/.local/bin ~/.config

# ─── Step 1: Install Neovim (extracted AppImage — containers rarely have FUSE) ─
echo ""
echo "[1/4] Installing Neovim ${NVIM_VERSION}..."

rm -rf ~/nvim-portable ~/nvim-linux-x86_64.appimage

curl -fLo ~/nvim-linux-x86_64.appimage "$NVIM_URL"
echo "${NVIM_SHA256}  ${HOME}/nvim-linux-x86_64.appimage" | sha256sum -c -
chmod u+x ~/nvim-linux-x86_64.appimage

cd ~
./nvim-linux-x86_64.appimage --appimage-extract &>/dev/null
mv squashfs-root nvim-portable
rm ~/nvim-linux-x86_64.appimage
ln -sf ~/nvim-portable/usr/bin/nvim ~/.local/bin/nvim

echo "  Neovim installed: $(~/.local/bin/nvim --version | head -1)"

# ─── Step 2: Clone config ─────────────────────────────────────────────────────
echo ""
echo "[2/4] Fetching Neovim config..."

if [[ -d "$CONFIG_DIR" ]]; then
    echo "  Config already present at ${CONFIG_DIR}, skipping clone."
else
    git clone "$CONFIG_REPO" "$CONFIG_DIR"
    echo "  Cloned ${CONFIG_REPO} → ${CONFIG_DIR}"
fi

# ─── Step 3: Install dependencies ─────────────────────────────────────────────
echo ""
echo "[3/4] Installing dependencies (ripgrep, pyright, tree-sitter-cli)..."

if ! command -v rg &>/dev/null; then
    curl -fLo "/tmp/${RIPGREP_TARBALL}" "$RIPGREP_URL"
    tar -xzf "/tmp/${RIPGREP_TARBALL}" -C /tmp
    mv "/tmp/ripgrep-${RIPGREP_VERSION}-x86_64-unknown-linux-musl/rg" ~/.local/bin/
    rm -rf "/tmp/ripgrep-${RIPGREP_VERSION}-x86_64-unknown-linux-musl" "/tmp/${RIPGREP_TARBALL}"
    echo "  ripgrep installed to ~/.local/bin/rg"
else
    echo "  ripgrep already present — skipping."
fi

if command -v npm &>/dev/null; then
    npm install -g pyright tree-sitter-cli
else
    echo "  WARNING: npm not found — skipping pyright + tree-sitter-cli."
    echo "           Install Node.js in your container, then run:"
    echo "             npm install -g pyright tree-sitter-cli"
fi

# ─── Step 4: PATH ─────────────────────────────────────────────────────────────
echo ""
echo "[4/4] Ensuring ~/.local/bin is on PATH..."

if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' ~/.bashrc 2>/dev/null; then
    {
        echo ''
        echo '# Neovim (portable install)'
        echo 'export PATH="$HOME/.local/bin:$PATH"'
    } >> ~/.bashrc
    echo "  Added ~/.local/bin to PATH in ~/.bashrc"
else
    echo "  ~/.local/bin already on PATH"
fi

# Browser-based dev container terminals support truecolor but don't advertise it.
# Set COLORTERM so Neovim's termguicolors actually renders.
if ! grep -q 'export COLORTERM=truecolor' ~/.bashrc 2>/dev/null; then
    echo 'export COLORTERM=truecolor' >> ~/.bashrc
    echo "  Set COLORTERM=truecolor in ~/.bashrc"
else
    echo "  COLORTERM=truecolor already set"
fi

echo ""
echo "══════════════════════════════════════════════════════"
echo "  Done! Open a new shell (or 'source ~/.bashrc'),"
echo "  then run 'nvim' — Lazy.nvim will install plugins."
echo "══════════════════════════════════════════════════════"
