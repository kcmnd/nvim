#!/usr/bin/env bash
# deploy-nvim.sh — Deploy Neovim (AppImage) + your config + tmux to a remote server
# Usage: ./deploy-nvim.sh user@server
#
# What it does:
#   1. Downloads the Neovim AppImage on the remote server (no sudo needed)
#   2. Extracts it (in case FUSE isn't available)
#   3. Symlinks nvim into ~/bin
#   4. Syncs your local Neovim config (~/.config/nvim) to the server
#   5. Adds ~/bin to PATH in .bashrc if not already there
#   6. Prints a quick-start guide

set -euo pipefail

# ─── Config ───────────────────────────────────────────────────────────────────
NVIM_VERSION="latest"  # change to e.g. "v0.11.5" for a pinned version
NVIM_URL="https://github.com/neovim/neovim/releases/${NVIM_VERSION}/download/nvim-linux-x86_64.appimage"
LOCAL_NVIM_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
# ──────────────────────────────────────────────────────────────────────────────

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 user@server"
    exit 1
fi

SERVER="$1"

echo "══════════════════════════════════════════════════════"
echo "  Deploying Neovim to ${SERVER}"
echo "══════════════════════════════════════════════════════"

# ─── Step 1: Install Neovim AppImage on the remote server ─────────────────────
echo ""
echo "[1/4] Downloading and extracting Neovim AppImage on ${SERVER}..."

ssh "$SERVER" bash -s -- "$NVIM_URL" << 'REMOTE_INSTALL'
    set -euo pipefail
    NVIM_URL="$1"

    mkdir -p ~/bin ~/.config

    # Clean up any previous portable install
    rm -rf ~/nvim-portable ~/nvim-linux-x86_64.appimage

    echo "  Downloading from ${NVIM_URL}..."
    curl -fLo ~/nvim-linux-x86_64.appimage "$NVIM_URL"
    chmod u+x ~/nvim-linux-x86_64.appimage

    # Try running directly first (needs FUSE); if that fails, extract
    if ~/nvim-linux-x86_64.appimage --version &>/dev/null; then
        echo "  FUSE available — linking AppImage directly."
        ln -sf ~/nvim-linux-x86_64.appimage ~/bin/nvim
    else
        echo "  FUSE not available — extracting AppImage..."
        cd ~
        ./nvim-linux-x86_64.appimage --appimage-extract &>/dev/null
        mv squashfs-root nvim-portable
        rm ~/nvim-linux-x86_64.appimage
        ln -sf ~/nvim-portable/usr/bin/nvim ~/bin/nvim
    fi

    echo "  Neovim installed: $(~/bin/nvim --version | head -1)"
REMOTE_INSTALL

# ─── Step 2: Sync your Neovim config ─────────────────────────────────────────
echo ""
echo "[2/4] Syncing Neovim config to ${SERVER}..."

if [[ -d "$LOCAL_NVIM_CONFIG" ]]; then
    rsync -az --delete \
        --exclude '.git' \
        --exclude 'plugin/packer_compiled.lua' \
        "$LOCAL_NVIM_CONFIG/" "${SERVER}:~/.config/nvim/"
    echo "  Synced ${LOCAL_NVIM_CONFIG} → ~/.config/nvim/"
else
    echo "  WARNING: No local config found at ${LOCAL_NVIM_CONFIG}, skipping."
fi

# ─── Step 3: Ensure ~/bin is on PATH ─────────────────────────────────────────
echo ""
echo "[3/4] Ensuring ~/bin is on PATH..."

ssh "$SERVER" bash << 'REMOTE_PATH'
    if ! grep -q 'export PATH="$HOME/bin:$PATH"' ~/.bashrc 2>/dev/null; then
        echo '' >> ~/.bashrc
        echo '# Neovim (portable install)' >> ~/.bashrc
        echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
        echo "  Added ~/bin to PATH in ~/.bashrc"
    else
        echo "  ~/bin already on PATH"
    fi
REMOTE_PATH

# ─── Step 4: Verify ──────────────────────────────────────────────────────────
echo ""
echo "[4/4] Verifying installation..."

ssh "$SERVER" 'export PATH="$HOME/bin:$PATH" && nvim --version | head -1'

echo ""
echo "══════════════════════════════════════════════════════"
echo "  Done! Quick start:"
echo ""
echo "    ssh ${SERVER}"
echo "    tmux new -s work      # start a persistent session"
echo "    nvim .                 # your full config is ready"
echo ""
echo "  Reconnect later:"
echo "    ssh ${SERVER}"
echo "    tmux attach -t work"
echo "══════════════════════════════════════════════════════"
