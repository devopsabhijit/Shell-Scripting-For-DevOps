#!/usr/bin/env bash

set -Eeuo pipefail

readonly SCRIPT_NAME="$(basename "$0")"

# -----------------------------
# System Health Check Script
# -----------------------------

log() {
    printf "%-20s : %s\n" "$1" "$2"
}

main() {
    echo "======================================"
    echo "       SYSTEM HEALTH CHECK REPORT"
    echo "======================================"

    log "Date & Time" "$(date)"
    log "Logged-in User" "$(whoami)"
    log "Hostname" "$(hostname)"

    echo
    echo "Disk Usage:"
    df -h --total | grep -E "Filesystem|total"

    echo
    echo "Memory Usage:"
    free -h
}

main "$@"
