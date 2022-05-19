#!/bin/sh

if ! command -v git &> /dev/null; then
    echo "Missing dependency: git"
    exit
fi

{
    echo "Cloning with SSH..."
    git clone --separate-git-dir=$HOME/Git/.dotfiles \
        git@github.com:GreenNick/linux-dotfiles.git $HOME/dotfile-tmp
} || {
    echo "Failed to clone with SSH."
    echo "Cloning with HTTPS..."
    git clone --separate-git-dir=$HOME/Git/.dotfiles \
        https://github.com/GreenNick/linux-dotfiles.git $HOME/dotfile-tmp
} || {
    echo "Failed to clone with HTTPS."
    echo "Repository clone failed, exiting script."
    exit
}

echo "Repository clone successful."

rm -rf $HOME/dotfile-tmp

alias config='/usr/bin/git --git-dir=$HOME/Git/.dotfiles --work-tree=$HOME'
config checkout -f

