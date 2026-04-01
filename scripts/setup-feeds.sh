#!/usr/bin/env bash
# setup-feeds.sh
# Update and install iStoreOS feeds
# Steps are taken directly from the official iStoreOS/OpenWrt build documentation:
#   1. ./scripts/feeds update -a
#   2. ./scripts/feeds install -a

set -euo pipefail

echo "[feeds] Updating all feeds..."
./scripts/feeds update -a

echo "[feeds] Installing all feed packages..."
./scripts/feeds install -a

echo "[feeds] Feeds ready."
