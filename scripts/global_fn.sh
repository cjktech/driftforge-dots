#!/bin/bash
# =============================================================================
# # driftforge-dots - global_fn.sh
# # global functions: functions used in all install scripts
# =============================================================================

# -----------------------------------------------------------------------------
# Output helpers
# -----------------------------------------------------------------------------
info()    { echo "[INFO]    $*"; }
success() { echo "[OK]      $*"; }
warn()    { echo "[WARNING] $*"; }
abort()   { echo "[ABORT]   $*" >&2; exit 1; }

# -----------------------------------------------------------------------------
# Error trap — print line number on failure
# -----------------------------------------------------------------------------
trap 'echo "[ERROR] Failed at line $LINENO in ${BASH_SOURCE[0]}. Aborting." >&2' ERR

# -----------------------------------------------------------------------------
# Check: Arch Linux only
# -----------------------------------------------------------------------------
check_arch() {
    if [ ! -f /etc/arch-release ]; then
        abort "This script is intended for Arch Linux only."
    fi
    success "Arch Linux detected."
}

# -----------------------------------------------------------------------------
# Check: must not run as root
# -----------------------------------------------------------------------------
check_not_root() {
    if [ "$EUID" -eq 0 ]; then
        abort "Do not run this script as root. Run as your normal user; sudo will be used where needed."
    fi
}

# -----------------------------------------------------------------------------
# Check: command exists on the system
# Usage: command_exists yay
# -----------------------------------------------------------------------------
command_exists() {
    command -v "$1" &>/dev/null
}

# -----------------------------------------------------------------------------
# Check: systemd service exists
# Usage: service_exists bluetooth
# -----------------------------------------------------------------------------
service_exists() {
    systemctl list-unit-files --type=service | grep -q "^$1.service"
}
