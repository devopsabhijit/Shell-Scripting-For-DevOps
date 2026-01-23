#!/usr/bin/env bash

set -Eeuo pipefail

readonly SCRIPT_NAME="$(basename "$0")"
readonly BACKUP_BASE="$HOME/Desktop/Linux/backups"
readonly DATE="$(date +%F)"
readonly BACKUP_FILE="logs_backup_${DATE}.tar.gz"
readonly BACKUP_PATH="${BACKUP_BASE}/${BACKUP_FILE}"

log() {
    printf "%-25s : %s\n" "$1" "$2"
}

fail() {
    log "Status" "FAILED"
    log "Reason" "$1"
    exit 1
}

main() {
    echo "======================================"
    echo "   BACKUP VERIFICATION REPORT"
    echo "======================================"

    log "Date & Time" "$(date)"
    log "Hostname" "$(hostname)"
    log "Backup File" "$BACKUP_PATH"

    # Check existence
    if [[ ! -f "$BACKUP_PATH" ]]; then
        fail "Backup file not found"
    fi

    # Check non-zero size
    if [[ ! -s "$BACKUP_PATH" ]]; then
        fail "Backup file is empty"
    fi

    # Integrity check (gzip)
    if ! gzip -t "$BACKUP_PATH" >/dev/null 2>&1; then
        fail "Backup archive is corrupted"
    fi

    log "Status" "SUCCESS"
    log "Integrity Check" "PASSED"

    echo "======================================"
}

main "$@"

