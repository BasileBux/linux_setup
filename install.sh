#!/bin/bash

dotfilesRepo="git@github.com:BasileBux/dotfiles.git"

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

read -p "Do you have write access to the dotfiles repo ? (Y/N) > " ownedRepoUser
if [ $ownedRepoUser == [yY] ]; then
    ownedRepo=true
else if [ $ownedRepoUser == [nN] ]; then
    ownedRepo=false
else
    echo "Aborting installation your choice wasn't right"
fi

mkdir ~/tmp

# Tools -----------------------------------------------------------------------------------------------
# sh tools.sh version
sudo dnf install git curl wget gcc make cmake grim slurp fastfetch
sudo dnf group install "C Development Tools and Libraries"
sudo dnf group install "Container Management"

# Docker
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl start docker

# Lazygit
sudo dnf copr enable atim/lazygit -y
sudo dnf install lazygit

# EXTRAS
if [ $1 = full ]; then
    sudo dnf install yt-dlp yt-dlp-zsh-completion
fi


# Programming -----------------------------------------------------------------------------------------
sudo dnf install golang python3 python3-pip maven

# Sdkman
curl -s "https://get.sdkman.io" | bash

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh


# Fonts -----------------------------------------------------------------------------------------------
mkdir ~/.local/share/fonts

# install getnf to download nerdfonts easily
curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash

# GeistMono
getnf -i GeistMono

# EXTRAS
if [ $1 = full ]; then
# Monocraft
wget https://github.com/IdreesInc/Monocraft/releases/download/v4.0/Monocraft-ttf-otf.zip > ~/tmp
unzip ~/tmp/Monocraft-ttf-otf.zip -d ~/.local/share/fonts
fi

fc-cache -fv


# Apps ------------------------------------------------------------------------------------------------
# Zed
curl -f https://zed.dev/install.sh | sh # Currently problems with this

# Visual Studio Code
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf check-update
sudo dnf install code

# Zen borwser (Flatpak) -> currently problems with appimage
flatpak install flathub io.github.zen_browser.zen

# Kitty terminal
sudo dnf install kitty blueman neovim mpv

# VLC with dnf groups
sudo dnf group install "VideoLAN Client"

# EXTRAS
if [ $1 = full ]; then
# Vesktop
flatpak install flathub dev.vencord.Vesktop

# Spotify
flatpak install flathub com.spotify.Client
fi


# Hyprland --------------------------------------------------------------------------------------------
sudo dnf install hyprland hyprlock hypridle waybar wofi wlogout


# Config ----------------------------------------------------------------------------------------------
# DOTFILES
cd ~/tmp

git clone git@github.com:BasileBux/dotfiles.git

# Move all folders in ~/.config
find ~/tmp/dotfiles -type d -maxdepth 1 -exec mv -t ~/.config {} +
mv ~/tmp/wallpaper.png ~/wallpaper.png

if [ $1 = true ]; then
    mv ~/tmp/dotfiles/.gitignore ~/.config/.gitignore
    cd ~/.config
    read -p "Enter branch name for dotfiles repo: " branchName
    git checkout -b $branchName
    echo "Your new branch was created and checked out."

else
    rm -rf ~/.config/.git
fi

rm -rf ~/tmp/dotfiles

# Visual Studio Code

# Install extensions
code --install-extension bierner.markdown-emoji
code --install-extension bierner.markdown-preview-github-styles
code --install-extension enkia.tokyo-night
code --install-extension miguelsolorio.fluent-icons
code --install-extension monokai.theme-monokai-pro-vscode
code --install-extension ms-vscode.cmake-tools
code --install-extension ms-vscode.cpptools
code --install-extension ms-vscode.cpptools-extension-pack
code --install-extension ms-vscode.makefile-tools
code --install-extension pkief.material-icon-theme
code --install-extension twxs.cmake
code --install-extension vscodevim.vim

sudo dnf upgrade -y

clear
read -p "Installation completed! Do you want to download LaTeX? (Y/N) > " latexUser
if [ latexUser == [yY ]; then
    sudo dnf install texlive-scheme-full
    clear
    echo "Installation completed have fun!\nRestart the system to be sure!"
else
    echo "You didn't seem to want LaTeX. Installation completed have fun!\nRestart the system to be sure!"
fi
