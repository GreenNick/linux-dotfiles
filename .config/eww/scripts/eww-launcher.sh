#!/bin/sh
SCRIPT_DIR="$XDG_CONFIG_HOME/eww/scripts"
. "$SCRIPT_DIR/.env"

if [ ! -s "$CACHE_FILE" ]; then
  ICON_THEME=$(eww get icon-theme)
  "$SCRIPT_DIR/search.sh" "$ICON_THEME"
fi

"$SCRIPT_DIR/filter.sh"
case "$1" in
  --wayland)
    eww open eww-launcher-wl
    break
    ;;
  --x11)
    eww open eww-launcher-x11
    break
    ;;
  *)
    echo "Invalid argument supplied, must be '--wayland' or '--x11'"
    ;;
esac
