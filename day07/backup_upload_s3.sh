#!/usr/bin/env bash

set -Eeuo pipefail

readonly SCRIPT_NAME="$(basename "$0")"

readonly PATH_OF_BACKUP_DIRECTORY="backups"
readonly BACKUP_BASE="$HOME/$PATH_OF_BACKUP_DIRECTORY"

readonly DATE="$(date +%F)"
readonly BACKUP_FILE="logs_backup_${DATE}.tar.gz"
readonly BACKUP_PATH="${BACKUP_BASE}/${BACKUP_FILE}"

readonly VERIFY_SCRIPT="$HOME/path/to/verify_script.sh"

readonly S3_BUCKET="BUCKET_NAME"
readonly S3_PREFIX="daily-logs"

log() {
    printf "%-30s : %s\n" "$1" "$2"
}

fail() {
    log "Status" "FAILED"
    log "Reason" "$1"
    exit 1
}

main() {
    echo "======================================"
    echo "      BACKUP UPLOAD TO S3 REPORT"
    echo "======================================"

    log "Date & Time" "$(date)"
    log "Hostname" "$(hostname)"

    command -v aws >/dev/null || fail "AWS CLI not installed"

    [[ -x "$VERIFY_SCRIPT" ]] || fail "Verify script not executable: $VERIFY_SCRIPT"

    if ! "$VERIFY_SCRIPT" >/dev/null 2>&1; then
        fail "Backup verification failed — upload aborted"
    fi
    log "Verification" "PASSED"

    [[ -f "$BACKUP_PATH" ]] || fail "Backup file not found: $BACKUP_PATH"

    aws s3 cp \
        "$BACKUP_PATH" \
        "s3://${S3_BUCKET}/${S3_PREFIX}/${BACKUP_FILE}" \
        --only-show-errors

    log "Upload Status" "SUCCESS"
    log "S3 Location" "s3://${S3_BUCKET}/${S3_PREFIX}/${BACKUP_FILE}"

    echo "======================================"
}

main "$@"
