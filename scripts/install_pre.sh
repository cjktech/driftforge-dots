#!/bin/bash
# =============================================================================
# driftforge-dots — install_pre.sh
# Pre-installation: build tools, yay, GPU drivers, bootloader config
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/global_fn.sh"

# -----------------------------------------------------------------------------
# System checks
# -----------------------------------------------------------------------------
info "Checking system..."
check_arch
check_not_root

# -----------------------------------------------------------------------------
# Core build tools
# -----------------------------------------------------------------------------
info "Installing core build tools..."
sudo pacman -S --needed --noconfirm base-devel git stow
success "Core build tools installed."

# -----------------------------------------------------------------------------
# Enable multilib
# -----------------------------------------------------------------------------
info "Enabling multilib repository..."

if grep -q '^\[multilib\]' /etc/pacman.conf; then
    success "multilib already enabled, skipping"
else
    sudo sed -i '/^#\[multilib\]/{
        s/^#//
        n
        s/^#//
    }' /etc/pacman.conf
    success "multilib enabled."
    info "Syncing pacman databases..."
    sudo pacman -Sy
fi

# -----------------------------------------------------------------------------
# Install yay (AUR helper)
# -----------------------------------------------------------------------------
if command -v yay &>/dev/null; then
    success "yay is already installed, skipping."
else
    info "Installing yay..."
    local_yay_dir="$(mktemp -d)"
    git clone https://aur.archlinux.org/yay.git "$local_yay_dir"
    (cd "$local_yay_dir" && makepkg -si --noconfirm)
    rm -rf "$local_yay_dir"
    success "yay installed."
fi

# -----------------------------------------------------------------------------
# GPU detection
# -----------------------------------------------------------------------------
info "Detecting GPU..."

GPU_INFO=$(lspci | grep -iE "VGA|3D|Display")
info "Detected: $GPU_INFO"

if echo "$GPU_INFO" | grep -qi "nvidia"; then

    # -------------------------------------------------------------------------
    # Nvidia — check card generation
    # -------------------------------------------------------------------------
    info "Nvidia GPU detected. Checking generation..."

    if echo "$GPU_INFO" | grep -qiE "GTX (4[0-9]{2}|5[0-9]{2}|6[0-9]{2}|7[0-9]{2}|9[0-9]{2}|10[0-9]{2})"; then
        # -------------------------------------------------------------------------
        # Legacy GPU path — Pascal (GTX 10xx), Maxwell (GTX 9xx) and older
        # -------------------------------------------------------------------------
        # Currently not supported by this installer.
        # These cards require the legacy nvidia-580xx-dkms driver from the AUR
        # since nvidia-open dropped support for Pascal and older in driver 590.
        #
        # To add support in the future, uncomment and implement the block below:
        #
        # warn "Legacy Nvidia GPU detected (Pascal / Maxwell or older)."
        # warn "Installing legacy driver: nvidia-580xx-dkms from AUR."
        # yay -S --needed --noconfirm nvidia-580xx-dkms
        #
        # Ref: https://wiki.archlinux.org/title/NVIDIA
        # Ref: Arch news 2025-12-20 — NVIDIA 590 drops Pascal support
        # -------------------------------------------------------------------------
        echo ""
        warn "==========================================================="
        warn "  Unsupported GPU detected."
        warn "  nvidia-open requires Turing (RTX 20xx / GTX 1650) or newer."
        warn "  Pascal (GTX 10xx), Maxwell (GTX 9xx), and older cards are"
        warn "  not supported by this installer at this time."
        warn ""
        warn "  Refer to the Arch wiki for manual legacy driver setup:"
        warn "  https://wiki.archlinux.org/title/NVIDIA"
        warn "==========================================================="
        echo ""
        abort "Unsupported GPU. Aborting."

    else
        # -------------------------------------------------------------------------
        # Modern Nvidia path — Turing (RTX 20xx / GTX 1650) and newer
        # nvidia-open is the standard driver as of driver 590 (Arch news 2025-12-20)
        # -------------------------------------------------------------------------
        info "Modern Nvidia GPU detected (Turing or newer). Installing nvidia-open..."
        sudo pacman -S --needed --noconfirm nvidia-open nvidia-utils egl-wayland
        success "Nvidia drivers installed."
    fi

    # -------------------------------------------------------------------------
    # Bootloader detection — add nvidia kernel parameters
    # -------------------------------------------------------------------------
    info "Detecting bootloader for nvidia kernel parameter setup..."

    if [ -d /sys/firmware/efi ]; then
        if [ -f /boot/grub/grub.cfg ]; then
            BOOTLOADER="grub"
        elif [ -f /boot/loader/loader.conf ]; then
            BOOTLOADER="systemd-boot"
        else
            BOOTLOADER="unknown"
        fi
    else
        if [ -f /boot/grub/grub.cfg ]; then
            BOOTLOADER="grub"
        else
            BOOTLOADER="unknown"
        fi
    fi

    info "Bootloader detected: $BOOTLOADER"

    NVIDIA_PARAMS="nvidia-drm.modeset=1 nvidia.NVreg_PreserveVideoMemoryAllocations=1"

    case "$BOOTLOADER" in
        grub)
            info "Adding nvidia kernel parameters to GRUB..."
            GRUB_CFG="/etc/default/grub"
            if grep -q "nvidia-drm.modeset=1" "$GRUB_CFG"; then
                success "Nvidia parameters already present in GRUB config."
            else
                sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"/GRUB_CMDLINE_LINUX_DEFAULT=\"${NVIDIA_PARAMS} /" "$GRUB_CFG"
                sudo grub-mkconfig -o /boot/grub/grub.cfg
                success "GRUB updated with nvidia parameters."
            fi
            ;;
        systemd-boot)
            info "Adding nvidia kernel parameters to systemd-boot..."
            ENTRY=$(find /boot/loader/entries -name "*.conf" | head -n 1)
            if [ -z "$ENTRY" ]; then
                warn "No systemd-boot entry found. Add manually: $NVIDIA_PARAMS"
            elif grep -q "nvidia-drm.modeset=1" "$ENTRY"; then
                success "Nvidia parameters already present in systemd-boot entry."
            else
                sudo sed -i "s/^options /options ${NVIDIA_PARAMS} /" "$ENTRY"
                success "systemd-boot entry updated with nvidia parameters."
            fi
            ;;
        unknown)
            warn "Could not detect bootloader. Add these kernel parameters manually:"
            warn "  $NVIDIA_PARAMS"
            warn "Refer to your bootloader documentation."
            ;;
    esac

elif echo "$GPU_INFO" | grep -qi "amd\|radeon"; then
    # -------------------------------------------------------------------------
    # AMD — no kernel params needed
    # -------------------------------------------------------------------------
    info "AMD GPU detected. Installing mesa and vulkan drivers..."
    sudo pacman -S --needed --noconfirm mesa vulkan-radeon libva-mesa-driver
    success "AMD drivers installed."

else
    warn "Could not detect GPU (Nvidia or AMD). Skipping driver installation."
    warn "Install drivers manually before proceeding."
fi

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------
echo ""
echo "============================================================"
echo "  install_pre.sh complete."
echo "  Next step: run ./Scripts/install_pkg.sh"
echo "============================================================"
