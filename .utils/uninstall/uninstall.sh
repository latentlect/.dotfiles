#!/usr/bin/env sh

while read path; do
    sudo rm -rf $HOME/$path
done < "$HOME/.utils/uninstall/paths"
