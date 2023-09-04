#!/bin/sh
SCRIPT_DIR="$XDG_CONFIG_HOME/eww/scripts"
. "$SCRIPT_DIR/.env"

xdg_subdirs() {
  echo "$XDG_DATA_HOME:$XDG_DATA_DIRS" \
    | awk -v dir="$1" '{
      split($0, arr, ":");
      for (i in arr)
        print arr[i] ~ /\w+\/$/ ? arr[i] dir : arr[i] "/" dir
      }'
}

find_icon_path () {
  THEME=$1
  if [ -f "$2" ]; then
    ICON_PATH=$2
  fi

  if [ -z "$ICON_PATH" ] && [ -d "$DOT_ICONS" ]; then
    DIR="$HOME/.icons/$THEME"
    ICON_PATH=$(find "$DIR" -path "$DIR/scalable*/$2.svg")
    ICON_PATH=${ICON_PATH:-$(find "$DIR" -path "$DIR/32*/$2.svg" \
                                      -o -path "$DIR/32*/$2.png")}
  fi

  if [ -z "$ICON_PATH" ]; then
    ICON_PATH=$(xdg_subdirs "icons/$THEME" \
      | while read -r DIR; do
          if [ ! -d "$DIR" ]; then
            continue
          fi

          CURR=$(find "$DIR" -path "$DIR/scalable*/$2.svg")
          CURR=${CURR:-$(find "$DIR" -path "$DIR/32*/$2.svg" \
                                  -o -path "$DIR/32*/$2.png")}

          if [ -n "$CURR" ]; then
            echo "$CURR"
            break
          fi
        done)
  fi

  if [ -z "$ICON_PATH" ] && [ "$THEME" != "hicolor" ]; then
    find_icon_path hicolor "$2"
  elif [ -z "$ICON_PATH" ]; then
    echo "$2"
  else
    echo "$ICON_PATH" | head -n 1
  fi
}

xdg_desktop_parse() {
  PARSE=false
  HIDDEN=false
  NO_DISPLAY=false
  while read -r LINE; do
    if [ "$LINE" = "[Desktop Entry]" ]; then
      PARSE=true
      continue
    fi

    if [ $PARSE = "true" ]; then
      case $LINE in
        \[*\])
          break;;
        Name=*)
          NAME=${LINE#*=};;
        Icon=*)
          ICON=${LINE#*=};;
        Exec=*)
          EXEC=${LINE#*=};;
        Hidden=*)
          HIDDEN=${LINE#*=};;
        NoDisplay=*)
          NO_DISPLAY=${LINE#*=};;
      esac
    fi
  done < "$1"

  if [ "$HIDDEN" = "true" ] || [ "$NO_DISPLAY" = "true" ]; then
    return
  fi

  ICON=$(find_icon_path "$2" "$ICON")
  EXEC=$(echo "$EXEC" | sed -e 's/"/\\"/g' -e 's/ %\w//g')

  printf '{"name":"%s", "icon": "%s", "exec": "%s"}\n' \
    "$NAME" "$ICON" "$EXEC"
}

APPS=$(xdg_subdirs "applications" \
  | while read -r DIR; do [ -d "$DIR" ] && echo "$DIR"; done \
  | xargs -I{} find {} -name "*.desktop" \
  | while read -r FILE; do xdg_desktop_parse "$FILE" "$1"; done \
  | awk '{ s = (NR == 1 ? $0 : s", "$0) } END { print "["s"]" }')

mkdir -p "$CACHE_DIR/eww-launcher"
echo "$APPS" > "$CACHE_FILE"

