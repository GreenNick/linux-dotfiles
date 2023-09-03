#!/bin/sh
SCRIPT_DIR="$XDG_CONFIG_HOME/eww/scripts"
. "$SCRIPT_DIR/.env"

if [ ! -s "$CACHE_FILE" ]; then
  ICON_THEME=$(eww get icon-theme)
  "$SCRIPT_DIR/search.sh" "$ICON_THEME"
fi

"$SCRIPT_DIR/filter.sh"
eww open eww-launcher
