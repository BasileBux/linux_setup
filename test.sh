#!/bin/bash

read -p "Do you have write access to the dotfiles repo ? (Y/N) > " userAnswer
if [ "$userAnswer" = "y" ] || [ "$userAnswer" = "Y" ]; then
    ownedRepo=true
elif [ "$userAnswer" = "n" ] || [ "$userAnswer" = "N" ]; then
    ownedRepo=false
# else
#     echo "Aborting installation, your choice wasn't right."
#     exit 1
fi
