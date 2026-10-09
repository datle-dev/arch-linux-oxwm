#!/bin/sh

# install oxwm build dependencies
sudo pacman -S --needed \
  base-devel \
  freetype2 \
  fontconfig \
  libx11 \
  libxft \
  libxinerama \
  zig \
  --noconfirm

# install oxwm default applications, utilities, display manager, and x11 display resolution utility
sudo pacman -S alacritty dmenu git ly openssh xorg-xrandr --noconfirm

# enable ssh
sudo systemctl enable --now sshd

# install fonts because minimal arch install won't have them,
# then reload font cache
sudo pacman -S ttf-dejavu ttf-liberation noto-fonts --noconfirm
fc-cache-fv

# clone oxwm repo and build
mkdir -p ~/src
cd ~/src
git clone https://github.com/tonybanters/oxwm
cd oxwm
sudo zig build -Doptimize=ReleaseSmall --prefix /usr

# install nightly build of neovim
cd /opt
sudo curl -L -O https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz
sudo tar -xf nvim-linux-x86_64.tar.gz --one-top-level=nvim --strip-components=1
sudo ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim

# get default oxwm config file
cd
oxwm --init

# create .xinitrc, point to custom startup script
cat << 'EOF' > ~/.xinitrc
#!/bin/sh
exec "$HOME/.config/oxwm/startup.sh"
EOF

# create custom startup script
cat << 'EOF' > ~/.config/oxwm/startup.sh
#!/bin/sh
xrandr --output Virtual-1 --mode 1920x1080
exec oxwm > "$HOME/oxwm.log" 2>&1
EOF

# make both executable
chmod +x ~/.xinitrc
chmod +x ~/.config/oxwm/startup.sh

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
