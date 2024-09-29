#!/bin/bash

dotfilesRepoSsh="git@github.com:BasileBux/dotfiles.git"
dotfilesRepoHttps="https://github.com/BasileBux/dotfiles.git"

sudo dnf install lsb-release -y

# Check gnome and correct fedora
desktop_env=$(echo "$XDG_CURRENT_DESKTOP" | tr '[:upper:]' '[:lower:]')

if command -v lsb_release &> /dev/null; then
    distro=$(lsb_release -si)
else
    echo "lsb_release command not found. Unable to determine Linux distribution and version."
    exit 1
fi

if [ "$desktop_env" != "gnome" ] && [ "${distro,,}" != "fedora" ]; then
    echo "The base system is incorrect. This install works only on Fedora workspace with gnome"
    exit 1
fi


read -p "Do you have write access to the dotfiles repo ? (Y/N) > " userAnswer
if [ "$userAnswer" = "y" ] || [ "$userAnswer" = "Y" ]; then
    ownedRepo=true
elif [ "$userAnswer" = "n" ] || [ "$userAnswer" = "N" ]; then
    ownedRepo=false
else
    echo "Aborting installation, your choice wasn't right."
    exit 1
fi

cd ~

sudo dnf upgrade -y

mkdir ~/tmp

# Tools -----------------------------------------------------------------------------------------------
# sh tools.sh version
sudo dnf install git curl wget gcc make cmake grim slurp fastfetch eza fzf zoxide bat -y
sudo dnf group install "C Development Tools and Libraries" -y
sudo dnf group install "Container Management" -y

# Docker
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo -y
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo systemctl start docker

# Lazygit
sudo dnf copr enable atim/lazygit -y
sudo dnf install lazygit -y

# EXTRAS
sudo dnf install yt-dlp yt-dlp-zsh-completion -y


# Programming -----------------------------------------------------------------------------------------
sudo dnf install golang python3 python3-pip maven -y

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

wget https://github.com/IdreesInc/Monocraft/releases/download/v4.0/Monocraft-ttf-otf.zip > ~/tmp
unzip ~/tmp/Monocraft-ttf-otf.zip -d ~/.local/share/fonts

fc-cache -fv


# Apps ------------------------------------------------------------------------------------------------
# Zed
curl -f https://zed.dev/install.sh | sh # Currently problems with this

# Visual Studio Code
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf check-update -y
sudo dnf install code -y

# Zen borwser (Flatpak) -> currently problems with appimage
flatpak install flathub io.github.zen_browser.zen -y

# Kitty terminal
sudo dnf install kitty blueman neovim mpv -y

# VLC with dnf groups
sudo dnf group install "VideoLAN Client" -y

# Vesktop
flatpak install flathub dev.vencord.Vesktop -y

# Spotify
flatpak install flathub com.spotify.Client -y


# Hyprland --------------------------------------------------------------------------------------------
sudo dnf install hyprland hyprlock hypridle waybar wofi wlogout -y


# Config ----------------------------------------------------------------------------------------------
# DOTFILES
cd ~/.config

if [ $ownedRepo = true ]; then
    git clone $dotfilesRepoSsh
else
    git clone $dotfilesRepoHttps
fi

# Move all folders (except Code) in ~/.config
mv Code/User/settings.json ~/.config/tmp-Code/User/settings.json
mv wallpaper.png ~/wallpaper.png

# Config vscode

if [ $ownedRepo = true ]; then
    read -p "Enter branch name for dotfiles repo: " branchName
    git checkout -b $branchName
    echo "Your new branch was created and checked out."
fi

rm -rf ~/tmp/dotfiles

# Visual Studio Code
# Opening vscode will create the files we need
code
sleep 10
kill $(pgrep -o code)

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
read -p "Installation completed! Do you want to download LaTeX ?(it's pretty long and heavy) (Y/N) > " latexUser
if [ "$latexUser" = "y" ] || [ "$latexUser" = "Y" ]; then
    pip3 install Pygments
    sudo dnf install texlive-scheme-full
    clear
    echo "Installation completed have fun!\nRestart the system to be sure!"
else
    echo "You didn't seem to want LaTeX. Installation completed have fun!\nRestart the system to be sure!"
fi
