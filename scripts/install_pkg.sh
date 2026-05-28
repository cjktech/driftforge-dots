#!/bin/bash
# =============================================================================
# driftforge-dots — Scripts/install_pkg.sh
# Package installation: reads .lst files and installs via pacman and yay
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

if ! command_exists yay; then
    abort "yay not found. Please run install_pre.sh first."
fi
success "yay found."

# -----------------------------------------------------------------------------
# Helpers - parse and classify
# -----------------------------------------------------------------------------
FAILED_PACKAGES=()
PACMAN_PACKAGES=()
YAY_PACKAGES=()

parse_list() {
    local list_file="$1"

    if [ ! -f "$list_file" ]; then
	warn "Package list not found, skipping: $list_file"
	return
    fi

    grep -v '^\s*#' "$list_file" | grep -v '^\s*$' | awk '{print $1}'
}

classify_package() {
    local pkg="$1"

    if sudo pacman -Si "$pkg" &>/dev/null; then
	PACMAN_PACKAGES+=("$pkg")
	info "  [pacman] $pkg"
    elif yay -Si "$pkg" &>/dev/null; then
	YAY_PACKAGES+=("$pkg")
	info "  [AUR]    $pkg"
    else
	FAILED_PACKAGES+=("$pkg")
	warn "  [???]    $pkg - not found in pacman or AUR"
    fi
}

# -----------------------------------------------------------------------------
# Parse all list files and classify every package
# -----------------------------------------------------------------------------
info "Scanning package lists..."
echo ""

for list_file in \
    "$SCRIPT_DIR/pkg_core.lst" \
    "$SCRIPT_DIR/pkg_fonts.lst" \
    "$SCRIPT_DIR/pkg_extra.lst"; do

    info "Scanning $list_file..."

    packages=$(parse_list "$list_file")
    
    if [ -z "$packages" ]; then
	warn "No packages found in $list_file, skipping."
	continue
    fi

    while IFS= read -r pkg; do
	classify_package "$pkg"
    done <<< "$packages"

done
echo ""

# -----------------------------------------------------------------------------
# Report what was found before installing
# -----------------------------------------------------------------------------
info "Classification complete. Summary:"
echo ""
echo "  Pacman packages : ${#PACMAN_PACKAGES[@]}"
echo "  AUR packages    : ${#YAY_PACKAGES[@]}"
echo "  Not found       : ${#FAILED_PACKAGES[@]}"
echo ""

if [ ${#FAILED_PACKAGES[@]} -gt 0 ]; then
    warn "The following packages were not found and will be skipped:"
    for pkg in "${FAILED_PACKAGES[@]}"; do
	warn "  - $pkg"
    done
    echo ""
    warn "Check for typos in the .lst files or search the arch and AUR packages"
    echo ""
fi

# -----------------------------------------------------------------------------
# Abort if everything failed, otherwise confirm and install
# -----------------------------------------------------------------------------
TOTAL_VALID=$(( ${#PACMAN_PACKAGES[@]} + ${#YAY_PACKAGES[@]} ))

if [ "$TOTAL_VALID" -eq 0 ]; then
    abort "No valid packages to install. Check your .lst files."
fi

# -----------------------------------------------------------------------------
# Bulk install pacman packages
# -----------------------------------------------------------------------------
if [ ${#PACMAN_PACKAGES[@]} -gt 0 ]; then
    info "Installing ${#PACMAN_PACKAGES[@]} packages via pacman..."
    sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"
    success "Pacman packages installed."
fi

# -----------------------------------------------------------------------------
# Bulk install AUR packages
# -----------------------------------------------------------------------------
if [ ${#YAY_PACKAGES[@]} -gt 0 ]; then
    info "Installing ${#YAY_PACKAGES[@]} packages via yay..."
    yay -S --needed --noconfirm "${YAY_PACKAGES[@]}"
    success "AUR packages installed."
fi


# -----------------------------------------------------------------------------
# Final report
# -----------------------------------------------------------------------------
echo ""
if [ ${#FAILED_PACKAGES[@]} -gt 0 ]; then
    warn "==========================================================="
    warn "  Install complete with warnings."
    warn "  ${#FAILED_PACKAGES[@]} package(s) could not be found:"
    for pkg in "${FAILED_PACKAGES[@]}"; do
        warn "    - $pkg"
    done
    warn "==========================================================="
else
    success "All packages installed successfully."
fi

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------
echo ""
echo "============================================================"
echo "  install_pkg.sh complete."
echo "  Next step: run ./Scripts/install_pst.sh"
echo "============================================================"
