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
  diff \
  find \
  flex \
  gawk \
  gcc \
  getopt \
  grep \
  gzip \
  libc-dev \
  libncurses5-dev \
  libz-dev \
  make \
  patch \
  perl \
  python3 \
  rsync \
  subversion \
  unzip \
  which \
  xz-utils \
  zlib1g-dev \
  build-essential \
  clang \
  file \
  g++ \
  libssl-dev \
  wget \
  curl \
  git

echo "[deps] All dependencies installed."
