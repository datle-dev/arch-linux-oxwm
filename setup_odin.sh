#!/bin/sh
set -euo pipefail

# install required apps
sudo pacman -S \
    base-devel \
    clang \
    unzip

# versions
ODIN_VERSION="dev-2026-10"
OLS_VERSION="dev-2026-08"

# temporary files and directories
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

ODIN_ARCHIVE="$TMP_DIR/odin.tar.gz"
OLS_ARCHIVE="$TMP_DIR/ols.zip"
ODIN_DIR="$TMP_DIR/odin"
OLS_DIR="$TMP_DIR/ols"

mkdir -p "$ODIN_DIR" "$OLS_DIR"

# download releases
curl -fL \
    "https://github.com/odin-lang/Odin/releases/download/$ODIN_VERSION/odin-linux-amd64-$ODIN_VERSION.tar.gz" \
    -o "$ODIN_ARCHIVE"

curl -fL \
    "https://github.com/DanielGavin/ols/releases/download/$OLS_VERSION/ols-x86_64-unknown-linux-gnu.zip" \
    -o "$OLS_ARCHIVE"

# extract archives
tar -xzf "$ODIN_ARCHIVE" \
    -C "$ODIN_DIR" \
    --strip-components=1

unzip -q "$OLS_ARCHIVE" -d "$OLS_DIR"

# rename binaries
mv "$OLS_DIR/ols-x86_64-unknown-linux-gnu" "$OLS_DIR/ols"
mv "$OLS_DIR/odinfmt-x86_64-unknown-linux-gnu" "$OLS_DIR/odinfmt"

# install into /opt
sudo mkdir -p /opt/odin /opt/ols
sudo cp -a "$ODIN_DIR/." /opt/odin/
sudo cp -a "$OLS_DIR/." /opt/ols/

# create symlinks
sudo ln -sfn /opt/odin/odin /usr/local/bin/odin
sudo ln -sfn /opt/ols/ols /usr/local/bin/ols
sudo ln -sfn /opt/ols/odinfmt /usr/local/bin/odinfmt
