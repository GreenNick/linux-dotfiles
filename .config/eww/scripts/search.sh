#!/bin/sh
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

  if [ -d "$HOME/.icons/$THEME" ]; then
    ICON_PATH=$(find "$HOME/.icons/$THEME/scalable" -name "$2.svg" \
      || find "$HOME/.icons/$THEME/32" -name "$2.svg" -or -name "$2.png")
  fi

  if [ -z "$ICON_PATH" ]; then
    ICON_PATH=$(xdg_subdirs "icons/$THEME" \
      | while read -r DIR; do [ -d "$DIR" ] && echo "$DIR"; done \
      | while read -r DIR; do
        find "$DIR/scalable" -name "$2.svg" \
          || find "$DIR/32" -name "$2.svg" -or -name "$2.png"
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

if [ ! -z "$XDG_CACHE_HOME" ]; then
  mkdir -p "$XDG_CACHE_HOME/eww-launcher"
  echo "$APPS" > "$XDG_CACHE_HOME/eww-launcher/desktop_entries"
fi
