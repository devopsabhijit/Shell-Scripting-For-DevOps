#!/usr/bin/env bash

set -Eeuo pipefail

readonly SCRIPT_NAME="$(basename "$0")"
readonly LOG_SOURCE="/var/log"
readonly BACKUP_BASE="/home/Desktop/backups"
readonly DATE="$(date +%F)"
readonly BACKUP_FILE="logs_backup_${DATE}.tar.gz"

log() {
    printf "%-20s : %s\n" "$1" "$2"
}

main() {
    echo "======================================"
    echo "        DAILY LOG BACKUP REPORT"
    echo "======================================"

    log "Date & Time" "$(date)"
    log "Hostname" "$(hostname)"

    # Create backup directory if not exists
    if [[ ! -d "$BACKUP_BASE" ]]; then
        mkdir -p "$BACKUP_BASE"
        log "Backup Dir" "Created $BACKUP_BASE"
    else
        log "Backup Dir" "Exists"
    fi

    # Create backup
    tar -czf "${BACKUP_BASE}/${BACKUP_FILE}" "$LOG_SOURCE"

    log "Backup Source" "$LOG_SOURCE"
    log "Backup File" "${BACKUP_BASE}/${BACKUP_FILE}"
    log "Backup Status" "SUCCESS"

    echo "======================================"
}

main "$@"

