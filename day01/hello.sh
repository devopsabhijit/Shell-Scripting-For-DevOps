#!/usr/bin/env bash

set -Eeuo pipefail

readonly SCRIPT_NAME="$(basename "$0")"

usage() 
{
   cat <<EOF
      Usage: $SCRIPT_NAME [options]
      Options:
          -h    Show help
EOF
}

main() 
{
   echo "Scales Safely, Fails Loudly and Respect Unix Conventions"
}

main "$@"
