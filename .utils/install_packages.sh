#!/usr/bin/env sh

sudo apt update -y

while read package; do
    sudo apt install -y $package
done < "$HOME/.utils/packages"

sudo apt update -y && sudo apt upgrade -y
sudo apt autoremove -y
