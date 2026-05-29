# driftforge-dots
Hyprland dotfiles inspired by machined metal, brass fixtures, and treated wood.

---

## Screenshots

W.I.P.

---

## Requirements

- Arch Linux
- A Turing (RTX 20xx / GTX 1650) or newer Nvidia GPU, or any modern AMD GPU
- An internet connection
- A non-root user with sudo access

---

## Install

Clone the repo and run the installer. 

```bash
sudo pacman -S --needed git base-devel
git clone git@github.com:cjktech/driftforge-dots.git
cd driftforge-dots/scripts
./install.sh
```

The installer runs in threee stages:
1. **Pre-install** - core build tools and drivers
2. **Packages** - installs all packages
3. **Post-install** - enableds services, docker and stows all configs

Please reboot after the install script completes.

---

## Package Lists

Packages are split into list files under 'scripts/'
Commented-out lines are intentional: uncomment what you need before installing.

---

## Reminders

The windowrules in the hypr config are hardcoded to windows on my base desktop, nad will probably do nothing on your device. Read these and change them where needed.
