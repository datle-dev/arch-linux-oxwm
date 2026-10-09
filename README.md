# arch-linux-oxwm

## Arch Linux

If installing archlinux in a VM, ensure that firmware is UEFI.

Install archlinux using `archinstall` script:
- Best-effort default partition layout
- Btrfs snapshots with Snapper
- Limine bootloader
- Xorg profile

## Optional Setup

Optionally install SSH and neovim to do setup remotely with preferred code editor.
Remote setup allows for copy + paste into local terminal.

### SSH

Install SSH.

```bash
sudo pacman -S openssh
```

Enable and immediately start SSH service.

```bash
sudo systemctl enable --now sshd
```

### neovim

Get latest nightly release of neovim.
Assuming `wget` is not installed, use `curl` instead and put prebuilt binary into `/opt`.

```bash
cd /opt
sudo curl -L -O https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz
sudo tar -xf nvim-linux-x86_64.tar.gz --one-top-level=nvim --strip-components=1
```

Create symlink.

```bash
sudo ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim
```

## Build oxwm

Install oxwm build dependencies.

```
sudo pacman -S --needed base-devel freetype2 fontconfig git libx11 libxft libxinerama zig
```

Make a `src` folder in home directory to build oxwm.

```bash
mkdir ~/src
cd ~/src
```

Clone oxwm repo and build.
Note `zig build` needs `sudo` permission because it will install binary to `/usr/bin`.

```bash
git clone https://github.com/tonybanters/oxwm
cd oxwm
sudo zig build -Doptimize=ReleaseSmall --prefix /usr
```

## Fonts

Minimal install comes with no fonts, so install them.

```bash
sudo pacman -S --needed ttf-dejavu ttf-liberation noto-fonts
```

Update font cache.

```bash
fc-cache -fv
```

Confirm `monospace` font exists.

```bash
fc-match monospace
```

## Default Programs

Install oxwm default terminal and launcher.

```bash
sudo pacman -S alacritty dmenu
```

## oxwm Setup

Initialize oxwm config file.

```bash
oxwm --init
```

## X11 setup

Create `~/.xinitrc`.

```bash
touch ~/.xinitrc
```

Add following.

```bash
#!/bin/sh

alacritty &
exec oxwm
```

Optionally direct oxwm output for debugging.

```bash
exec oxwm > "$HOME/oxwm.log" 2>&1
```

## Starting oxwm

After logging in, just run `startx`.

## Display Resolution for VM

Install `xorg-xrandr`.

```bash
sudo pacman -S xorg-xrandr
```

Check available displays and resolutions with `xrandr`.

```bash
xrandr
```

Set output and resolution.

```bash
xrandr --output Virtual-1 --mode 1920x1080
```
## Ly Display Manager

Install ly.

```bash
sudo pacman -S ly
```

```bash
sudo mkdir -p /usr/share/xsessions
```

Create a desktop entry in neovim.

```bash
nvim /usr/share/xsessions/oxwm.desktop
```

Add the following to the desktop entry.

```bash
[Desktop Entry]
Name=oxwm
Comment=oxwm X11 window manager
Exec=oxwm
Type=Application
```

Disable `getty` and enable `ly`.

```bash
sudo systemctl disable getty@tty1.service
sudo systemctl enable ly@tty1.service
```
