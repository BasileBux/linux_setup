#!/bin/bash

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
