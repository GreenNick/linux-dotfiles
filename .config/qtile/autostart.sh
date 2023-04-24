#!/bin/sh

# Use dex to start desktop entries according to XDG autostart specification
# Alternate package names used on other distros can be specified here
if [ -x "$(command -v dex-autostart)" ]; then
    dex-autostart -a
elif [ -x "$(command -v dex)" ]; then
    dex -a
fi
