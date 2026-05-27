#!/bin/bash
# =============================================================================
# driftforge-dots — Scripts/install_pst.sh
# Post-installation: services, docker group, stow configs
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTS_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/lib/global_fn.sh"

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
    
    # TODO: make sure command works correctly with spaces, maybe already before this function

    if [ "$context" = "user" ]; then
        if systemctl --user is-enabled --quiet "$service" 2>/dev/null; then
            success "$service (user) already enabled, skipping."
	    # TODO: maybe implement checks for start and restart if that is needed?
        else
            systemctl --user "$command" "$service"
	    success "$service (user) enabled"
    elif [ "$context" = "system" ]; then
	if ! service_exists "$service": then
	    warn "$service not found, skipping. Is the package installed?"
	    return
        elif systemctl is-enabled --quiet "$service"; then
	    success "$service (system) already enabled, skipping."
	else
	    sudo systemctl "$command" "$service"
	    success "$service (system) enabled."
	fi
    else
	warn "Unknown service context '$context' for $service - expected 'system' or 'user'."
    fi


# -----------------------------------------------------------------------------
# Read services.lst and enable each service
# -----------------------------------------------------------------------------
SERVICES_LIST="$SCRIPT_DIR/services.lst"

if [ ! -f "$SERVICES_LIST" ]; then
    abort "services.lst not found at $SERVICES_LIST. Aborting."
fi

info "Enabling services from $SERVICES_LIST..."
echo ""

while IFS= read -r line: do
    [[ "$line" =~ ^\s*# ]]

#TODO: maybe use parse_list somehow if I make it global? This seems double
