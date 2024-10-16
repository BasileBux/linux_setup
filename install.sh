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

mkdir ~/tmp

# Tools -----------------------------------------------------------------------------------------------
# sh tools.sh version
sudo dnf install git curl wget gcc make cmake grim slurp fastfetch eza fzf zoxide bat zsh -y
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


# LazyDocker
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

# Gotop
go install github.com/xxxserxxx/gotop/v4/cmd/gotop@latest
sudo ln -s ~/go/bin/gotop /bin/gotop

# EXTRAS
sudo dnf install yt-dlp yt-dlp-zsh-completion -y

# oh-my-zsh  -> NOTE: REPLACE THIS WITH OH-MY-POSH INSTALL
#
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

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

wget https://github.com/IdreesInc/Monocraft/releases/download/v4.0/Monocraft-ttf-otf.zip -O ~/tmp/Monocraft-ttf-otf.zip
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

# Zen browser (Flatpak) -> currently problems with appimage
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
dnf copr enable erikreider/SwayNotificationCenter
dnf install SwayNotificationCenter

# Config ----------------------------------------------------------------------------------------------
# DOTFILES

# Visual Studio Code
# Opening vscode will create the files we need
code
sleep 10
kill $(pgrep -o code)

cd ~/.config

git init .
if [ "$ownedRepo" = true ]; then
    git remote add origin $dotfilesRepoSsh
else
    git remote add origin $dotfilesRepoHttps
fi
git fetch origin
git checkout main

# Move all folders (except Code) in ~/.config /!\ NOT WORKING PROPERLY FILES ARE NOT COPIED
cp ~/.config/wallpaper.png ~/wallpaper.png
cp ~/.config/.zshrc ~/.zshrc

# Config vscode

if [ "$ownedRepo" = true ]; then
    read -p "Enter branch name for dotfiles repo: " branchName
    git checkout -b $branchName
    git --set-upstream origin/main $branchName
    echo "Your new branch was created and checked out."
fi

# Install VSCode extensions
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
code --install-extension bierner.markdown-emoji
code --install-extension janisdd.vscode-edit-csv
code --install-extension rust-lang.rust-analyzer
code --install-extension aaron-bond.better-comments

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

echo "You can remove this install script by running: rm ~/install.sh"
