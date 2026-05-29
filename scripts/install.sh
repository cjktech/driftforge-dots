#!/bin/bash
# =============================================================================
# driftforge-dots — Scripts/install.sh
# Main entry point — runs all install scripts in order
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/global_fn.sh"

# -----------------------------------------------------------------------------
# Welcome
# -----------------------------------------------------------------------------
echo ""
echo "============================================================"
echo "  driftforge-dots — installer"
echo "  Hyprland dotfiles by cjktech"
echo "============================================================"
echo ""

# -----------------------------------------------------------------------------
# System checks
# -----------------------------------------------------------------------------
info "Checking system..."
check_arch
check_not_root

# -----------------------------------------------------------------------------
# Confirm before proceeding
# -----------------------------------------------------------------------------
warn "This will install packages, enable services, and stow configs."
warn "Make sure you have reviewed the package lists before continuing."
echo ""
read -rp "  [?] Continue with installation? [y/n]: " confirm

case "$confirm" in
    y|Y) info "Starting installation..." ;;
    *)   abort "Installation cancelled by user." ;;
esac
echo ""

# -----------------------------------------------------------------------------
# Run install scripts in order
# -----------------------------------------------------------------------------
info "Step 1/3 — Pre-installation..."
bash "$SCRIPT_DIR/install_pre.sh"

echo ""
info "Step 2/3 — Package installation..."
bash "$SCRIPT_DIR/install_pkg.sh"

echo ""
info "Step 3/3 — Post-installation..."
bash "$SCRIPT_DIR/install_pst.sh"

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------
echo ""
echo "============================================================"
echo "  driftforge-dots installation complete."
echo ""
echo "  Next steps:"
echo "    1. Reboot your system"
echo "    2. Log in via greetd"
echo "    3. If you added docker, log out and back in for"
echo "       group changes to take effect"
echo "============================================================"
echo ""

#TODO: make this executable
