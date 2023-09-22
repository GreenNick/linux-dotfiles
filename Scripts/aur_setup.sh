#!/bin/sh

append_if_missing () {
  tr '\n' '\01' < "$1" | if ! grep -q "$(echo "$2" | tr '\n' '\01')"; then
    echo "$2" >> "$1"
  fi
}

if [ "$(id -u)" -ne 0 ]; then
  echo "Error: This script must run as root."
  echo "Make sure to check the contents of the script for malicious code."
  exit 1
fi

# Create the AUR user
AUR_DIR="/var/cache/aur"
useradd aur --system --home-dir "$AUR_DIR" --create-home

# Give AUR user permission to run pacman and pacsync
cat << EOF > /etc/sudoers.d/10-aur
aur ALL=(root) NOPASSWD: /usr/bin/pacman
aur ALL=(root) NOPASSWD: /usr/bin/pacsync
EOF

# Create alias (if not present) to run aurutils commands as AUR user
append_if_missing "$XDG_CONFIG_HOME/shell/system" "$(cat << EOF

# Run aurutils with aur user
alias aur="sudo -u aur aur"
EOF
)"

# Define local AUR repository
cat << EOF > /etc/pacman.d/aur
[options]
CacheDir = /var/cache/pacman/pkg $AUR_DIR
CleanMethod = KeepCurrent

[aur]
SigLevel = Optional TrustAll
Server = file://$AUR_DIR
EOF

# Include local AUR repository (if not present) in pacman config
append_if_missing /etc/pacman.conf "$(cat << 'EOF'

Include = /etc/pacman.d/aur
EOF
)"

# Create local AUR repository database
install -d "$AUR_DIR" -o aur
sudo -u aur sh -c "cd $AUR_DIR; repo-add aur.db.tar.gz"

# Sync local AUR repository with pacman
pacman -Sy

# Install aurutils
git clone https://aur.archlinux.org/aurutils.git "$AUR_DIR/aurutils"
chown -R aur "$AUR_DIR/aurutils"
sudo -u aur sh -c "cd $AUR_DIR/aurutils; makepkg -si"

# Clean up AUR directory
mv "$AUR_DIR/aurutils/"*.pkg.tar* "$AUR_DIR/"
rm -rf "$AUR_DIR/aurutils"

# Add aurutils to local AUR repository
sudo -u aur sh -c "cd $AUR_DIR; repo-add -n aur.db.tar.gz *.pkg.tar*"
pacman -Sy
