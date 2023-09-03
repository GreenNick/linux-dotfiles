#!/bin/sh
SCRIPT_DIR="$XDG_CONFIG_HOME/eww/scripts"
. "$SCRIPT_DIR/.env"

FILTER=$(jq -c \
  "[.[] | select(.name | ascii_upcase | contains(\"${1}\" | ascii_upcase))]
  | sort_by(.name | ascii_upcase)" \
  < "$CACHE_FILE")

eww update apps="$FILTER"
