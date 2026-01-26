#Prerequite to run this script

#1. backup_verification.sh must be executable
#2. sendmail (or mail agent) must be installed
#3. Script should be run via cron

#!/usr/bin/env bash

set -Eeuo pipefail

readonly SCRIPT_NAME="$(basename "$0")"
readonly VERIFY_SCRIPT="PATH_OF_SCRIPT_FILE"
readonly ALERT_EMAIL="EMAIL_ID"

log(){
    printf "%25s  : %s\n" "$1" "$2"
}

send_alert()
{
   local reason="$1"
      if ! command -v sendmail >/dev/null 2>&1; then
        log "Alert Error" "sendmail not installed"
        log "Alert Content" "$reason"
        return 1
      fi
   {
	echo "Subject: Backup Verification FAILED on $(hostname)"
        echo
        echo "Backup verification failed."
        echo
        echo "Hostname : $(hostname)"
        echo "Date     : $(date)"
        echo "Reason   : ${reason}"
   } | sendmail "$ALERT_EMAIL"
}
main()
{
    echo "======================================"
    echo "      BACKUP ALERTING REPORT"
    echo "======================================"

    if ! OUTPUT=$("$VERIFY_SCRIPT" 2>&1); then
        log "Verification" "FAILED"
        send_alert "$OUTPUT"
        exit 1
    fi

    log "Verification" "SUCCESS"
}
main "$@"
