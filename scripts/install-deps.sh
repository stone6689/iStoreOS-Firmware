#!/usr/bin/env bash
# install-deps.sh
# Install build dependencies required by iStoreOS (OpenWrt-based)
# Updated for Ubuntu 22.04 compatibility
# Reference: https://github.com/istoreos/istoreos README

set -euo pipefail

echo "[deps] Updating apt package lists..."
sudo apt-get update -qq

echo "[deps] Installing build dependencies for iStoreOS/OpenWrt..."
sudo apt-get install -y --no-install-recommends \
  build-essential \
  bison flex gawk gcc g++ gcc-multilib g++-multilib \
  gettext git libncurses5-dev libssl-dev libssl3 \
  python3 python3-dev python3-pyelftools python3-setuptools \
  zlib1g-dev file wget curl rsync subversion \
  ccache cmake automake autoconf libtool pkgconf \
  patch unzip tar bzip2 xz-utils cpio \
  libelf-dev libglib2.0-dev libgmp-dev \
  libmpc-dev libmpfr-dev libreadline-dev \
  texinfo help2man intltool ninja-build \
  scons swig xmlto xxd \
  lzma lzop p7zip-full p7zip \
  upx-ucl uglifyjs \
  libltdl-dev libc6-dev-i386 \
  asciidoc doxygen graphviz \
  msmtp nano vim \
  diffutils findutils grep gzip perl util-linux

# Install Python 2 if needed (some packages may require it)
if ! dpkg -l | grep -q python2; then
    echo "[deps] Installing Python 2 for compatibility..."
    sudo apt-get install -y python2 python2-dev
fi

echo "[deps] All dependencies installed."