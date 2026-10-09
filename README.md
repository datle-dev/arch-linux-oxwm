# arch-linux-oxwm

## archlinux

- Install archlinux using `archinstall` script
- For profile, choose Xorg

## oxwm

Install oxwm build dependencies

```
sudo pacman -S --needed base-devel freetype2 fontconfig git libx11 libxft libxinerama zig
```

Make a `src` folder in home directory, clone oxwm repo, and build.
Note `zig build` needs `sudo` permission because it will install binary to `/usr/local/bin`

```
mkdir ~/src
cd src
git clone https://github.com/tonybanters/oxwm
cd oxwm
sudo zig build -Doptimize=ReleaseSmall --prefix /usr
```
## fonts

Minimal install comes with no fonts so install them

```bash
sudo pacman -S --needed ttf-dejavu ttf-liberation noto-fonts
```

Update cache

```bash
fc-cache -fv
```

Confirm that `monospace` font exists

```bash
fc-match monospace
```

## default programs

### git

```bash
sudo pacman -S git
```

### terminal and launcher
Install oxwm default terminal and launcher

```bash
sudo pacman -S alacritty dmenu
```

### neovim

Get latest nightly release of neovim
Assuming `wget` is not installed, use `curl` instead
Put in `/opt`


```bash
cd /opt
sudo curl -L -O https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz
sudo tar -xvzf nvim-linux-x86_64.tar.gz -C nvim --strip-components=1
```

Create symlink

```bash
sudo ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim
```
## oxwm setup

Initialize oxwm config file

```bash
oxwm --init
```

## x11 setup

Create `~/.xinitrc`

```bash
touch ~/.xinitrc
```

## starting oxwm

after logging in, just run `startx`
