#!/bin/bash
# =============================================================================
# driftforge-dots — Scripts/install_pst.sh
# Post-installation: services, docker group, stow configs
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTS_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/global_fn.sh"

# -----------------------------------------------------------------------------
# System checks
# -----------------------------------------------------------------------------
info "Checking system..."
check_arch
check_not_root

# -----------------------------------------------------------------------------
# Helper — systemd services
# -----------------------------------------------------------------------------
enable_service() {
    local service="$1"
    local context="$2"
    local command="$3"

    if [ "$context" = "user" ]; then
        if systemctl --user is-enabled --quiet "$service" 2>/dev/null; then
            success "$service (user) already enabled, skipping."
        else
            systemctl --user $command "$service"
	    success "$service (user): $command enabled"
	fi
    elif [ "$context" = "system" ]; then
	if ! service_exists "$service"; then
	    warn "$service not found, skipping. Is the package installed?"
	    return
        elif systemctl is-enabled --quiet "$service"; then
	    success "$service (system) already enabled, skipping."
	else
	    sudo systemctl $command "$service"
	    success "$service (system): $command enabled."
	fi
    else
	warn "Unknown service context '$context' for $service - expected 'system' or 'user'."
    fi
}

# -----------------------------------------------------------------------------
# Read services.lst and enable each service
# -----------------------------------------------------------------------------
SERVICES_LIST="$SCRIPT_DIR/services.lst"

if [ ! -f "$SERVICES_LIST" ]; then
    abort "services.lst not found at $SERVICES_LIST. Aborting."
fi

info "Enabling services from $SERVICES_LIST..."
echo ""

while IFS= read -r line; do
    [[ "$line" =~ ^\s*# ]] && continue
    [[ -z "${line// }" ]] && continue

    service=$(echo "$line" | cut -d'|' -f1)
    context=$(echo "$line" | cut -d'|' -f2)
    command=$(echo "$line" | cut -d'|' -f3)

    if [ -z "$service" ] || [ -z "$context" ] || [ -z "$command" ]; then
	warn "Malformed line in services list, skipping: '$line'"
	continue
    fi

    enable_service "$service" "$context" "$command"

done < "$SERVICES_LIST"

echo ""
success "Services configured."

# -----------------------------------------------------------------------------
# Docker group
# -----------------------------------------------------------------------------
info "Configuring docker group..."

if command_exists docker; then
    if groups "$USER" | grep -q '\bdocker\b'; then
	success "$USER is already in the docker group, skipping."
    else
	sudo usermod -aG docker "$USER"
	success "$USER added to docker group."
	warn "Docker group change takes effect on next login."
    fi
else
    warn "DOcker not found, skipping. Install docker first if you plan to use it."
fi

# -----------------------------------------------------------------------------
# Stow configs
# -----------------------------------------------------------------------------
info "Stowing configs..."

CONFIGS_DIR="$DOTS_DIR/configs"

if [ ! -d "$CONFIGS_DIR" ]; then 
    abort "configs/ directory not found at $CONFIGS_DIR. Aborting."
fi

for config_dir in "$CONFIGS_DIR"/*/; do
    config_name=$(basename "$config_dir")
    target="$HOME/.config/$config_name"

    if [ -e "$target" ] && [ ! -L "$target" ]; then
	warn "$target exists as a real path - removing before stowing..."
	rm -rf "$target"
    fi

    info "Stowing $config_name..."
    stow_output=$(stow -d "$CONFIGS_DIR" -t ~ "$config_name" 2>&1

    stow_exit=$?

    if [ $stow_exit -eq 0 ]; then
	success "$config_name stowed."
    else
	echo ""
        warn "==========================================================="
        warn "  Conflict detected while stowing: $config_name"
        warn ""
        warn "  Stow output:"
        while IFS= read -r stow_line; do
            warn "    $stow_line"
        done <<< "$stow_output"
        warn ""
        warn "  A real file already exists at the target location."
        warn "  Check the script for faults, or remove it manually."
        warn "==========================================================="
        echo ""

	read -rp "  [?] Skip $config_name and continue, or abort? [s/a]: " choice

	case "$choice" in
	    s|S) warn "$config_name skipped. Resolve the conflict mannually later." ;;
	    a|A) abort "Aborted by user." ;;
	    *)   warn "Unrecognised input. Skipping $config_name to be safe." ;;
	esac
	echo ""
    fi
done

success "Config stowing complete."

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------
echo ""
echo "============================================================"
echo "  install_pst.sh complete."
echo ""
echo "  Next steps:"
echo "    1. Reboot your system"
echo "    2. Log in via greetd"
echo "============================================================"

