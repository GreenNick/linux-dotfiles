#!/bin/sh

THEME="sugar-candy"
THEME_PATH="/usr/share/sddm/themes/$THEME"

if [ ! -d "$THEME_PATH" ]; then
    echo "Install theme '$THEME' before running this script"
    exit 1
fi

# Set sddm theme
sudo sh -c 'cat > /etc/sddm.conf' << EOF
[Theme]
Current=$THEME
EOF

# Run sddm through wayland
sudo sh -c 'cat > /etc/sddm.conf.d/10-wayland.conf' << EOF
[General]
DisplayServer=wayland
EOF

# Copy desktop wallpaper to theme directory
sudo mkdir -p "$THEME_PATH/Backgrounds"
sudo cp "$HOME/Pictures/Wallpaper.png" "$THEME_PATH/Backgrounds/Wallpaper.png"

# Copy theme configuration to theme directory
sudo cp "$XDG_CONFIG_HOME/sddm/theme.conf" "$THEME_PATH/theme.conf"
