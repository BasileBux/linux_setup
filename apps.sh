#!/bin/bash

# Zed
curl -f https://zed.dev/install.sh | sh

# Visual Studio Code
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

dnf check-update
sudo dnf install code

# Zen borwser (flatpak) WARNING CHANGE TO APPIMAGE FUCK FLATPAK
flatpak install flathub io.github.zen_browser.zen

# Jetbrains toolbox
curl -L https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.4.2.32922.tar.gz >
