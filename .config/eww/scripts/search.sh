#!/bin/sh
IFS=':' read -ra DIRS <<< $XDG_DATA_DIRS
DIRS+=($XDG_DATA_HOME)
FILES=()
for DIR in "${DIRS[@]}"; do
  if [[ $DIR != */ ]]; then
    DIR="${DIR}/applications"
  else
    DIR="${DIR}applications"
  fi

  if [[ -d $DIR ]]; then
    FILES+=($(find $DIR/*.desktop))
  fi
done

for FILE in "${FILES[@]}"; do
  PARSE=false
  HIDDEN=false
  NO_DISPLAY=false
  while IFS='' read -r LINE; do
    if [[ $LINE == "[Desktop Entry]" ]]; then
      PARSE=true
      continue
    fi

    if [[ $PARSE == "true" ]]; then
      case $LINE in
        \[*\])
          break;;
        Name=*)
          NAME=${LINE#*=};;
        Icon=*)
          ICON=${LINE#*=};;
        Hidden=*)
          HIDDEN=${LINE#*=};;
        NoDisplay=*)
          NO_DISPLAY=${LINE#*=};;
      esac
    fi
  done < $FILE

  if [[ $HIDDEN == "true" || $NO_DISPLAY == "true" ]]; then
    continue
  fi
  echo $NAME
done
