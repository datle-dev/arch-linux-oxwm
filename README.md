# arch-linux-oxwm

## archlinux

If installing archlinux in a VM, ensure that firmware is UEFI.

Install archlinux using `archinstall` script:
- Best-effort default partition layout
- Btrfs snapshots with Snapper
- Limine bootloader
- Xorg profile

## oxwm

Install oxwm build dependencies.

```
sudo pacman -S --needed base-devel freetype2 fontconfig git libx11 libxft libxinerama zig
```

Make a `src` folder in home directory to build oxwm.

```bash
mkdir ~/src
cd src
```

Clone oxwm repo and build.
Note `zig build` needs `sudo` permission because it will install binary to `/usr/local/bin`.

```bash
git clone https://github.com/tonybanters/oxwm
cd oxwm
sudo zig build -Doptimize=ReleaseSmall --prefix /usr
```

## fonts

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

## neovim

Get latest nightly release of neovim.
Assuming `wget` is not installed, use `curl` instead and put prebuilt binary into `/opt`.

```bash
cd /opt
sudo curl -L -O https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz
sudo tar -xvzf nvim-linux-x86_64.tar.gz -C nvim --strip-components=1
```

Create symlink.

```bash
sudo ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim
```
## oxwm setup

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
