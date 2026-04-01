#!/usr/bin/env bash
# inject-plugins.sh
# Injects third-party plugins into the OpenWrt source tree before compilation.
#
# Plugins handled:
#   1. luci-app-openclash  — sparse-checkout (official OpenClash build method)
#   2. luci-app-passwall   — feeds.conf.default (official PassWall build method)
#
# Also pre-downloads:
#   - Clash Meta (mihomo) kernel → files/etc/openclash/core/clash_meta
#
# Must be run from the openwrt/ source root.
# Usage: bash ../scripts/inject-plugins.sh <arch>
#   arch: x86_64 | arm64

set -euo pipefail

ARCH="${1:-x86_64}"

# ---------------------------------------------------------------------------
# 1. OpenClash — sparse-checkout into package/
#    Official build method from: https://github.com/vernesong/OpenClash
# ---------------------------------------------------------------------------
echo "[plugins] Adding luci-app-openclash..."

mkdir -p package/luci-app-openclash
cd package/luci-app-openclash
git init -q
git remote add origin https://github.com/vernesong/OpenClash.git
git config core.sparsecheckout true
echo "luci-app-openclash" >> .git/info/sparse-checkout
git pull --depth 1 origin master
cd ../..

echo "[plugins] luci-app-openclash ready."

# ---------------------------------------------------------------------------
# 2. PassWall — official build method from: https://github.com/xiaorouji/openwrt-passwall
#
#    Requires two repos:
#      - openwrt-passwall-packages : all proxy core dependencies
#      - openwrt-passwall          : the LuCI application
#
#    Per official README: feeds must be inserted at the TOP of feeds.conf.default
#    so passwall_packages takes priority over the default feeds for conflicting pkgs.
#    Then remove conflicting packages from feeds/packages/net to avoid version
#    conflicts (xray-core, sing-box, etc. are provided by passwall_packages).
# ---------------------------------------------------------------------------
echo "[plugins] Configuring PassWall feeds..."

# Append PassWall feeds into feeds.conf (the official iStoreOS feeds.conf written
# by setup-feeds.sh). passwall_packages must come before passwall_luci so that
# proxy core packages are resolved first and don't conflict with default feed versions.
cat >> feeds.conf << 'PWFEEDS'
src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git;main
src-git passwall_luci https://github.com/Openwrt-Passwall/openwrt-passwall.git;main
PWFEEDS

echo "[plugins] Updating PassWall feeds..."
# Only update the two newly added PassWall feeds; the rest are handled by setup-feeds.sh
./scripts/feeds update passwall_packages passwall_luci

# Remove ALL conflicting packages from default feeds that passwall_packages provides.
# Full list from official PassWall README:
echo "[plugins] Removing conflicting packages from default feeds..."
rm -rf \
  feeds/packages/net/xray-core \
  feeds/packages/net/v2ray-geodata \
  feeds/packages/net/sing-box \
  feeds/packages/net/chinadns-ng \
  feeds/packages/net/dns2socks \
  feeds/packages/net/hysteria \
  feeds/packages/net/ipt2socks \
  feeds/packages/net/microsocks \
  feeds/packages/net/naiveproxy \
  feeds/packages/net/shadowsocks-libev \
  feeds/packages/net/shadowsocks-rust \
  feeds/packages/net/shadowsocksr-libev \
  feeds/packages/net/simple-obfs \
  feeds/packages/net/tcping \
  feeds/packages/net/trojan-plus \
  feeds/packages/net/tuic-client \
  feeds/packages/net/v2ray-plugin \
  feeds/packages/net/xray-plugin \
  feeds/packages/net/geoview \
  feeds/packages/net/shadow-tls || true

# Also remove stale luci-app-passwall if present in default luci feed
rm -rf feeds/luci/applications/luci-app-passwall || true

echo "[plugins] Installing PassWall feed packages..."
# Force-install passwall_packages first so all proxy cores are available
./scripts/feeds install -a -f -p passwall_packages
# Install the PassWall LuCI application
./scripts/feeds install luci-app-passwall

echo "[plugins] PassWall ready."

# ---------------------------------------------------------------------------
# 3. Download Clash Meta (mihomo) kernel for OpenClash
#    Placed at files/etc/openclash/core/clash_meta → baked into firmware image.
#    Source: https://github.com/MetaCubeX/mihomo/releases
# ---------------------------------------------------------------------------
echo "[plugins] Fetching latest mihomo (Clash Meta) kernel..."

MIHOMO_API="https://api.github.com/repos/MetaCubeX/mihomo/releases/latest"
LATEST_TAG=$(curl -fsSL "$MIHOMO_API" | grep '"tag_name"' | head -1 | sed 's/.*"tag_name": *"\(.*\)".*/\1/')
echo "[plugins] Latest mihomo tag: ${LATEST_TAG}"

if [ "$ARCH" = "x86_64" ]; then
    # amd64-compatible is the safest choice — supports widest CPU range for generic x86_64
    MIHOMO_FILE="mihomo-linux-amd64-compatible-${LATEST_TAG}.gz"
elif [ "$ARCH" = "arm64" ]; then
    MIHOMO_FILE="mihomo-linux-arm64-${LATEST_TAG}.gz"
else
    echo "[plugins] Unknown arch: ${ARCH}" >&2
    exit 1
fi

MIHOMO_URL="https://github.com/MetaCubeX/mihomo/releases/download/${LATEST_TAG}/${MIHOMO_FILE}"
echo "[plugins] Downloading: ${MIHOMO_URL}"

CORE_DIR="files/etc/openclash/core"
mkdir -p "${CORE_DIR}"
curl -fsSL --retry 3 "${MIHOMO_URL}" -o "${CORE_DIR}/clash_meta.gz"
gunzip -f "${CORE_DIR}/clash_meta.gz"
chmod +x "${CORE_DIR}/clash_meta"

echo "[plugins] mihomo kernel ready at ${CORE_DIR}/clash_meta"
echo "[plugins] All plugin injections complete."
