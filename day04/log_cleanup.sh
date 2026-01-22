#!/usr/bin/env bash

set -Eeuo pipefail

readonly SCRIPT_NAME="$(basename "$0")"
readonly BACKUP_BASE="/var/backups"
readonly RETENTION_DAYS=7

log() {
    printf "%-25s : %s\n" "$1" "$2"
}

main() {
    echo "======================================"
    echo "     LOG BACKUP CLEANUP REPORT"
    echo "======================================"

    log "Date & Time" "$(date)"
    log "Hostname" "$(hostname)"
    log "Retention Policy" "${RETENTION_DAYS} days"

    if [[ ! -d "$BACKUP_BASE" ]]; then
        log "Backup Directory" "Not found — nothing to clean"
        exit 0
    fi

    log "Backup Directory" "$BACKUP_BASE"

    # Find and delete old backups
    OLD_FILES=$(find "$BACKUP_BASE" \
        -type f \
        -name "*.tar.gz" \
        -mtime +"$RETENTION_DAYS")

    if [[ -z "$OLD_FILES" ]]; then
        log "Cleanup Status" "No old backups found"
    else
        echo
        echo "Files to be removed:"
        echo "$OLD_FILES"

        find "$BACKUP_BASE" \
            -type f \
            -name "*.tar.gz" \
            -mtime +"$RETENTION_DAYS" \
            -delete

        log "Cleanup Status" "Old backups deleted"
    fi

    echo "======================================"
}

main "$@"

