#!/usr/bin/env bash
# install-deps.sh
# Install build dependencies required by iStoreOS (OpenWrt-based)
# Reference: https://github.com/istoreos/istoreos README

set -euo pipefail

echo "[deps] Updating apt package lists..."
sudo apt-get update -qq

echo "[deps] Installing build dependencies..."
sudo apt-get install -y --no-install-recommends \
  binutils \
  bzip2 \
  diffutils \
  findutils \
  flex \
  gawk \
  gcc \
  grep \
  gzip \
  libc-dev \
  libncurses5-dev \
  zlib1g-dev \
  make \
  patch \
  perl \
  python3 \
  rsync \
  subversion \
  unzip \
  util-linux \
  xz-utils \
  build-essential \
  clang \
  file \
  g++ \
  libssl-dev \
  wget \
  curl \
  git

echo "[deps] All dependencies installed."
