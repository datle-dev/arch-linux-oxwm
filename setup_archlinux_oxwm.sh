#!/bin/sh
set -eu

# install oxwm build dependencies
sudo pacman -S --needed --noconfirm \
    base-devel \
    zig \
    git \
    curl \
    freetype2 \
    fontconfig \
    libx11 \
    libxft \
    libxinerama \
    alacritty \
    dmenu \
    ly \
    openssh \
    xorg-xauth \
    xorg-xrandr \
    ttf-dejavu \
    ttf-liberation \
    noto-fonts

# reload font cache
fc-cache -fv

# enable ssh
sudo systemctl enable --now sshd.service

# clone oxwm repo and build as local user
mkdir -p "$HOME/src" "$HOME/.local/bin"

if [ ! -d "$HOME/src/oxwm/.git" ]; then
    git clone https://github.com/tonybanters/oxwm \
        "$HOME/src/oxwm"
fi

cd "$HOME/src/oxwm"

zig build -Doptimize=ReleaseSmall \
    --prefix "$HOME/.local"

# install binary system-wide
sudo install -Dm755 \
    "$HOME/.local/bin/oxwm" \
    /usr/local/bin/oxwm

# install nightly build of neovim
NVIM_ARCHIVE=$(mktemp)
NVIM_DIR=$(mktemp -d)
trap 'rm -f "$NVIM_ARCHIVE"; rm -rf "$NVIM_DIR"' EXIT

curl -fL \
    https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz \
    -o "$NVIM_ARCHIVE"

tar -xzf "$NVIM_ARCHIVE" \
    -C "$NVIM_DIR" \
    --strip-components=1

sudo mkdir -p /opt/nvim
sudo cp -a "$NVIM_DIR/." /opt/nvim/
sudo ln -sfn /opt/nvim/bin/nvim /usr/local/bin/nvim

# get default oxwm config file
cd "$HOME"

mkdir -p "$HOME/.config/oxwm"

if [ ! -f "$HOME/.config/oxwm/config.lua" ]; then
    oxwm --init
fi

# create .xinitrc, point to custom startup script
cat > "$HOME/.config/oxwm/startup.sh" <<'EOF'
#!/bin/sh

xrandr --output Virtual-1 --mode 1920x1080

exec oxwm > "$HOME/oxwm.log" 2>&1
EOF

chmod 755 "$HOME/.config/oxwm/startup.sh"

# keep startx support
cat > "$HOME/.xinitrc" <<'EOF'
#!/bin/sh
exec "$HOME/.config/oxwm/startup.sh"
EOF

chmod 755 "$HOME/.xinitrc"

# create desktop session file that points to custom startup script
sudo install -Dm644 /dev/stdin /usr/share/xsessions/oxwm.desktop <<EOF
[Desktop Entry]
Name=oxwm
Comment=Minimal X11 window manager
Exec=$HOME/.config/oxwm/startup.sh
Type=Application
EOF

# disable getty and enable ly
sudo systemctl disable getty@tty1.service
sudo systemctl enable ly@tty1.service

echo "Setup complete. Reboot to start Ly."
