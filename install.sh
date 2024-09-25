#!/bin/bash

# Check gnome and correct fedora
desktop_env=$(echo "$XDG_CURRENT_DESKTOP" | tr '[:upper:]' '[:lower:]')

if command -v lsb_release &> /dev/null; then
  distro=$(lsb_release -si)
else
  echo "lsb_release command not found. Unable to determine Linux distribution and version."
  return
fi

if [ "$desktop_env" != "gnome" ] && [ "${distro,,}" != "fedora" ]; then
echo "The base system is incorrect. This install works only on Fedora workspace with gnome"
    return
fi


# Ask if extras will be installed too
read -p "Do you want to download the full version? \nFull version? (Y/N) > " versionUser

if [ $versionUser == [yY] ]; then
    version=full
else if [ $versionUser == [nN] ]; then
    version=light
else
    echo "Aborting installation your choice wasn't right"
fi

mkdir ~/tmp
sh tools.sh version
sh programming.sh version
sh fonts.sh version
sh apps.sh version
sh hyprland.sh

# Move configs accordingly
