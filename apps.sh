#!/bin/bash

# Zed
# curl -f https://zed.dev/install.sh | sh # Currently problems with this
flatpak install flathub io.github.zen_browser.zen

# Visual Studio Code
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf check-update
sudo dnf install code

# Zen borwser (AppImage) -> symlink it in /bin/zen-browser
bash <(curl https://updates.zen-browser.app/appimage.sh)
ln -s ~/.local/share/ZenBrowser.AppImage /bin/zen-browser

# Kitty terminal
sudo dnf install kitty

# VLC with dnf groups
sudo dnf group install "VideoLAN Client"

# Blueman
sudo dnf install blueman

# Neovim
sudo dnf install neovim

# MPV
sudo dnf install mpv

# EXTRAS
if [ $1 = full ]; then
# Vesktop
flatpak install flathub dev.vencord.Vesktop

# Spotify
flatpak install flathub com.spotify.Client
fi
