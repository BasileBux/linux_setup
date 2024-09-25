#!/bin/bash

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
