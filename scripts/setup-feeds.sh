#!/usr/bin/env bash
# setup-feeds.sh
# Update and install all iStoreOS feeds.
#
# By the time this script runs, feeds.conf has already been written with the
# official iStoreOS extra feeds (and PassWall feeds if building the plugins
# variant). This script just runs the standard update + install steps.
#
# Official iStoreOS extra feeds (written before calling this script):
#   src-git third_party    https://github.com/linkease/istore-packages.git;main
#   src-git diskman        https://github.com/jjm2473/luci-app-diskman.git;dev
#   src-git oaf            https://github.com/jjm2473/OpenAppFilter.git;dev7
#   src-git linkease_nas   https://github.com/linkease/nas-packages.git;master
#   src-git linkease_nas_luci https://github.com/linkease/nas-packages-luci.git;main
#   src-git jjm2473_apps   https://github.com/jjm2473/openwrt-apps.git;main
#
# Reference: https://fw0.koolcenter.com/iStoreOS/x86_64_efi/feeds.conf
#
# Must be run from the openwrt/ source root.

set -euo pipefail

echo "[feeds] Updating all feeds..."
./scripts/feeds update -a

echo "[feeds] Installing all feed packages..."
./scripts/feeds install -a

echo "[feeds] Feeds ready."
